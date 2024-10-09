import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:method_conf_app/data/umbraco/models/track.dart';
import 'package:method_conf_app/providers/conference_provider.dart';
import 'package:method_conf_app/providers/schedule_provider.dart';
import 'package:method_conf_app/providers/schedule_state_provider.dart';
import 'package:method_conf_app/widgets/app_banner.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/session_expansion_tile.dart';
import 'package:method_conf_app/widgets/page_loader.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static final EdgeInsets _horizontalPadding =
      const EdgeInsets.symmetric(horizontal: 20);

  Future? _scheduleFuture;

  @override
  void initState() {
    super.initState();

    final scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);
    final scheduleStateProvider =
        Provider.of<ScheduleStateProvider>(context, listen: false);

    _scheduleFuture = Future.wait([
      scheduleProvider.init(),
      scheduleStateProvider.init(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final conferenceProvider = Provider.of<ConferenceProvider>(context);
    final scheduleStateProvider = Provider.of<ScheduleStateProvider>(context);

    final eventDate = conferenceProvider.conference?.properties?.date;
    final currentTrack = scheduleStateProvider.currentTrack;

    return AppScreen(
      title: 'Schedule',
      body: PageLoader(
        future: _scheduleFuture,
        child: RefreshIndicator(
          onRefresh: () async {
            await scheduleProvider.refresh();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              if (eventDate != null) ..._buildBanner(eventDate),
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
              if (currentTrack != null)
                StickyHeader(
                  header: _buildTrackHeader(context, currentTrack),
                  content: Column(
                    children: [
                      const SizedBox(height: 15),
                      ...scheduleStateProvider.currentSessions.expand(
                        (session) => [
                          Padding(
                            padding: _horizontalPadding,
                            child: SessionExpansionTile(session: session),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ],
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
            scheduleStateProvider.handleControl(direction);
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

  List<Widget> _buildBanner(DateTime eventDate) {
    if (eventDate.isBefore(DateTime.now())) {
      return [Container()];
    }

    return [
      Padding(
        padding: _horizontalPadding,
        child: AppBanner(
          text: 'An immersive day of code, content, and more',
          buttonText: 'REGISTER NOW!',
          onButtonPress: () => launchUrl(Env.ticketUrl),
        ),
      ),
      const SizedBox(height: 20),
    ];
  }
}
