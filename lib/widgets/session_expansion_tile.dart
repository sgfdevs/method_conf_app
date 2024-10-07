import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

import 'package:method_conf_app/models/session.dart';
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
      child: ConfigurableExpansionTile(
        header: _buildHeader(expanded: false),
        headerExpanded: _buildHeader(expanded: true),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: AppHtml(markup: widget.session.description ?? 'Coming Soon'),
          )
        ],
      ),
    );
  }

  Widget _buildHeader({required bool expanded}) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  widget.session.time!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Visibility(
                visible: _sessionVisible(),
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
                  widget.session.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
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
          _buildSpeaker(),
        ],
      ),
    );
  }

  Widget _buildSpeaker() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: _speakerTapped,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: widget.session.speaker.image!,
              placeholder: (context, url) => const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.transparent),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
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
                  widget.session.speaker.name,
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
                      widget.session.speaker.title!,
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
    if (widget.disableSpeakerTap) {
      return;
    }

    AppNavigator.pushNamed(
      '/more/speakers/detail',
      arguments: widget.session.speaker,
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

  bool _sessionVisible() {
    return widget.session.beginTime.isBefore(_currentTime);
  }
}
