import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SESSIONS_KEY = 'app-sessions';

class SessionProvider extends ChangeNotifier {
  bool initialFetched = false;

  List<Session> _sessions = [];

  List<Session> get sessions {
    return _sessions;
  }

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
    if (initialFetched) {
      return;
    }

    var prefs = await SharedPreferences.getInstance();

    sessions = prefs
        .getStringList(SESSIONS_KEY)
        ?.map((s) => Session.fromJson(json.decode(s)))
        ?.toList() ?? [];

    await fetchSessions();
  }

  Future<void> fetchSessions() async {
    var url = '${Env.methodBaseUrl}/sessions.json';
    var res = await http.get(url);

    sessions = (json.decode(res.body)['data'] as List<dynamic>)
        .map((s) => Session.fromJson(s))
        .toList();

    var prefs = await SharedPreferences.getInstance();

    var sessionsJson = sessions.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList(SESSIONS_KEY, sessionsJson);
  }
}
