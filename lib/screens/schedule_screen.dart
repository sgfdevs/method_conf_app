import 'dart:async';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:method_conf_app/data/umbraco/models/conference.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/session_expansion_tile.dart';
import 'package:method_conf_app/widgets/page_loader.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:method_conf_app/data/umbraco/models/track.dart';
import 'package:method_conf_app/providers/conference_provider.dart';
import 'package:method_conf_app/providers/schedule_provider.dart';
import 'package:method_conf_app/providers/schedule_state_provider.dart';
import 'package:method_conf_app/widgets/app_banner.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  static final EdgeInsets _horizontalPadding =
      const EdgeInsets.symmetric(horizontal: 20);

  Future? _initFuture;

  final _scrollController = ScrollController();
  PageController? _pageController;

  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _initFuture = _init();

    _currentTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 30), _timerHandler);
  }

  Future<void> _init() async {
    final scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);
    final scheduleStateProvider =
        Provider.of<ScheduleStateProvider>(context, listen: false);

    await Future.wait([
      scheduleProvider.init(),
      scheduleStateProvider.init(),
    ]);

    _pageController =
        PageController(initialPage: scheduleStateProvider.currentColumnIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController?.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final conferenceProvider = Provider.of<ConferenceProvider>(context);
    final scheduleStateProvider = Provider.of<ScheduleStateProvider>(context);

    final eventDate = conferenceProvider.conference?.properties?.date;
    final currentTrack = scheduleStateProvider
        .getTrackAtColumn(scheduleStateProvider.currentColumnIndex);

    return AppScreen(
      title: 'Schedule',
      body: PageLoader(
        future: _initFuture,
        child: RefreshIndicator(
          onRefresh: () async {
            await scheduleProvider.refresh();
          },
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              if (eventDate != null) ..._buildRegisterBanner(eventDate),
              ..._buildSurveyBanner(
                  conferenceProvider.conference, _currentTime),
              if (eventDate != null) ...[
                Padding(
                  padding: _horizontalPadding,
                  child: Text(
                    DateFormat('EEEE, MMMM d\'${daySuffix(eventDate.day)}\', y')
                        .format(eventDate),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              StickyHeader(
                controller: _scrollController,
                header: currentTrack == null
                    ? Container()
                    : _buildTrackHeader(context, currentTrack),
                content: ExpandablePageView.builder(
                  controller: _pageController,
                  animationDuration: Duration(milliseconds: 100),
                  onPageChanged: (page) {
                    scheduleStateProvider.currentColumnIndex = page;
                    _fixStickyHeaderJumpingOnSmallerPages();
                  },
                  itemCount:
                      scheduleProvider.grid.elementAtOrNull(0)?.length ?? 0,
                  itemBuilder: (context, index) {
                    final sessions =
                        scheduleStateProvider.getSessionsAtColumn(index);

                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        ...sessions.expand(
                          (session) => [
                            Padding(
                              padding: _horizontalPadding,
                              child: SessionExpansionTile(session: session),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackHeader(BuildContext context, Track track) {
    var scheduleStateProvider = Provider.of<ScheduleStateProvider>(context);

    return Container(
      color: AppColors.accent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTrackControlIcon(scheduleStateProvider, ControlDirection.prev),
          Text(
            track.name ?? '',
            style: const TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          _buildTrackControlIcon(scheduleStateProvider, ControlDirection.next),
        ],
      ),
    );
  }

  Widget _buildTrackControlIcon(
      ScheduleStateProvider scheduleStateProvider, ControlDirection direction) {
    final enabled = direction == ControlDirection.next
        ? scheduleStateProvider.isNextEnabled
        : scheduleStateProvider.isPrevEnabled;

    return Visibility(
      visible: enabled,
      maintainState: true,
      maintainSize: true,
      maintainAnimation: true,
      child: IconButton(
        onPressed: () {
          if (enabled) {
            if (direction == ControlDirection.next) {
              _pageController?.nextPage(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic);
            } else {
              _pageController?.previousPage(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic);
            }
          }
        },
        icon: Icon(
          direction == ControlDirection.next
              ? Icons.chevron_right
              : Icons.chevron_left,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  List<Widget> _buildRegisterBanner(DateTime eventDate) {
    if (eventDate.isBefore(DateTime.now())) {
      return [Container()];
    }

    return [
      Padding(
        padding: _horizontalPadding,
        child: AppBanner(
          text: 'An immersive day of code, content, and more',
          buttonText: 'REGISTER NOW!',
          onButtonPress: () => launchUrl('${Env.methodBaseUrl}/register'),
        ),
      ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> _buildSurveyBanner(
      Conference? conference, DateTime currentTime) {
    final surveyUrl = conference?.properties?.surveyUrl;
    final fullUrl = surveyUrl?.fullUrl;
    final surveyAvailableAt = conference?.properties?.surveyAvailableAt;

    if (fullUrl == null ||
        surveyAvailableAt == null ||
        currentTime.isBefore(surveyAvailableAt)) {
      return [Container()];
    }

    return [
      Padding(
        padding: _horizontalPadding,
        child: AppBanner(
          text: 'Tell us what you thought of the conference!',
          buttonText: surveyUrl?.title ?? '',
          onButtonPress: () => launchUrl(fullUrl),
        ),
      ),
      const SizedBox(height: 20),
    ];
  }

  void _timerHandler(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  // This is a hacky fix that scrolls by one pixel when there's
  // conditions that will cause the sticky header to jump. This
  // happens  whenever we're scrolled down below a siblings
  // page max height  and we switch to that sibling page.
  void _fixStickyHeaderJumpingOnSmallerPages() {
    final animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    var prevHeight = _scrollController.position.maxScrollExtent;

    animationController.addListener(() {
      final currentHeight = _scrollController.position.maxScrollExtent;

      final isBottom = _scrollController.position.atEdge &&
          _scrollController.position.pixels != 0;

      if (currentHeight < prevHeight && isBottom) {
        _scrollController.jumpTo(_scrollController.offset - 1);
      }

      prevHeight = currentHeight;
    });

    animationController.addStatusListener((status) {
      if (status.isCompleted) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }
}
