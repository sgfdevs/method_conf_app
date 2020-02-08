import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:method_conf_app/models/speaker.dart';
import 'package:method_conf_app/providers/speaker_provider.dart';
import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/models/session.dart';

const SESSIONS_KEY = 'app-sessions';

class SessionProvider extends ChangeNotifier {
  final SpeakerProvider speakerProvider;

  bool _initialFetched = false;

  List<Session> _sessions = [];

  SessionProvider({this.speakerProvider});

  List<Session> get sessions => _sessions;

  set sessions(List<Session> newSessions) {
    _sessions = newSessions;
    notifyListeners();
  }

  List<Session> get mainSessions {
    var _main = sessions.where((s) => s.type == 'Main').toList();

    var lunchSession = sessions.firstWhere(
      (s) => s.type == 'Lunch',
      orElse: () => null,
    );

    if (lunchSession != null) {
      _main.add(lunchSession);
    }

    _main.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return _main;
  }

  List<Session> get workshopSessions {
    var _workshop = _sessions.where((s) => s.type == 'Workshop').toList();

    var lunchSession = sessions.lastWhere(
      (s) => s.type == 'Lunch',
      orElse: () => null,
    );

    if (lunchSession != null) {
      _workshop.add(lunchSession);
    }

    _workshop.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return _workshop;
  }

  List<Session> get keynoteSessions {
    return _sessions.where((s) => s.type == 'Keynote').toList();
  }

  Future<void> fetchInitialSession() async {
    if (_initialFetched) {
      return;
    }

    var prefs = await SharedPreferences.getInstance();

    sessions = prefs
            .getStringList(SESSIONS_KEY)
            ?.map((s) => Session.fromJson(json.decode(s)))
            ?.toList() ??
        [];

    if (sessions.length > 0) {
      // refresh in background if we found some in storage
      fetchSessions();
    } else {
      await fetchSessions();
    }

    _initialFetched = true;
  }

  Future<void> fetchSessions() async {
    var url = '${Env.methodBaseUrl}/sessions.json';
    var res = await http.get(url);

    sessions = (json.decode(res.body)['data'] as List<dynamic>)
        .map((s) => Session.fromJson(s))
        .toList();

    speakerProvider.setSpeakersFromSessions(sessions);

    var prefs = await SharedPreferences.getInstance();

    var sessionsJson = sessions.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList(SESSIONS_KEY, sessionsJson);
  }

  Session getSessionForSpeaker(Speaker speaker) {
    return sessions.firstWhere(
      (session) => session.speaker.name == speaker.name,
      orElse: () => null,
    );
  }
}
