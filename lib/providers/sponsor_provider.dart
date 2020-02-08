import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/models/sponsor.dart';

const SPONSOR_KEY = 'app-sponsrs';

class SponsorProvider extends ChangeNotifier {
  bool _initialFetched;

  List<Sponsor> _sponsors = [];

  List<Sponsor> get sponsors {
    return _sponsors;
  }

  set sponsors(List<Sponsor> newSponsors) {
    _sponsors = newSponsors;
    notifyListeners();
  }

  Future<void> fetchInitialSponsors() async {
    if (_initialFetched) {
      return;
    }

    var prefs = await SharedPreferences.getInstance();

    sponsors = prefs
        .getStringList(SPONSOR_KEY)
        ?.map((s) => Sponsor.fromJson(json.decode(s)))
        ?.toList() ?? [];

    await fetchSponsors();
  }

  Future<void> fetchSponsors() async {
    var url = '${Env.methodBaseUrl}/sponsors.json';
    var res = await http.get(url);

    sponsors = (json.decode(res.body)['data'] as List<dynamic>)
        .map((s) => Sponsor.fromJson(s))
        .toList();

    var prefs = await SharedPreferences.getInstance();

    var sessionsJson = sponsors.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList(SPONSOR_KEY, sessionsJson);
  }
}