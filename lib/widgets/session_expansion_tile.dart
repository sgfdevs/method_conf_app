import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:intl/intl.dart';
import 'package:method_conf_app/data/umbraco/image_url.dart';
import 'package:method_conf_app/data/umbraco/models/session.dart';
import 'package:method_conf_app/data/umbraco/models/speaker.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';

class SessionExpansionTile extends StatefulWidget {
  final Session session;
  final bool disableSpeakerTap;

  const SessionExpansionTile({
    super.key,
    required this.session,
    this.disableSpeakerTap = false,
  });

  @override
  State<SessionExpansionTile> createState() => _SessionExpansionTileState();
}

class _SessionExpansionTileState extends State<SessionExpansionTile> {
  late DateTime _currentTime;
  late Timer _timer;

  Speaker? get speaker => widget.session.properties?.speakers.firstOrNull;
  String get description =>
      widget.session.properties?.description?.markup.trim() ?? '';

  @override
  void initState() {
    super.initState();

    _currentTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 30), _timerHandler);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutralExtraLight,
      padding: const EdgeInsets.all(10),
      child: description == ''
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildHeader(expanded: false)],
            )
          : ConfigurableExpansionTile(
              header: _buildHeader(expanded: false),
              headerExpanded: _buildHeader(expanded: true),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: AppHtml(markup: description),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader({required bool expanded}) {
    final start = widget.session.properties?.start;
    final name = widget.session.name;

    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: start != null
                    ? Text(
                        DateFormat('h:mm a').format(start),
                        style: const TextStyle(fontSize: 16),
                      )
                    : null,
              ),
              Visibility(
                visible: _sessionFeedbackVisible(),
                child: TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: AppColors.accent),
                  onPressed: _sessionFeedbackTapped,
                  child: const Text(
                    'Session Feedback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  name ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              if (description != '')
                Row(
                  children: <Widget>[
                    Text(
                      expanded ? 'Less' : 'More',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  ],
                )
            ],
          ),
          const SizedBox(height: 8),
          if (speaker != null) _buildSpeaker(),
        ],
      ),
    );
  }

  Widget _buildSpeaker() {
    final profileImageUrl = speaker?.properties?.profileImage?.url;

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: _speakerTapped,
          child: ClipOval(
            child: profileImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl(profileImageUrl, width: 50, height: 50),
                    placeholder: (context, url) => const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.transparent),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _speakerTapped,
                child: Text(
                  speaker?.name ?? '',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      speaker?.properties?.jobTitle ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _speakerTapped() {
    final currentSpeaker = speaker;
    if (widget.disableSpeakerTap || currentSpeaker == null) {
      return;
    }

    AppNavigator.pushNamed(
      '/more/speakers/detail',
      arguments: currentSpeaker,
    );
  }

  void _sessionFeedbackTapped() {
    AppNavigator.pushNamed(
      '/more/feedback',
      arguments: widget.session,
    );
  }

  void _timerHandler(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  bool _sessionFeedbackVisible() {
    return widget.session.properties?.start?.isBefore(_currentTime) ?? false;
  }
}
