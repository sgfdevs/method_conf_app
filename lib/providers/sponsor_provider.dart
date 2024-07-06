import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/models/sponsor.dart';

const SPONSOR_KEY = 'app-sponsrs';

class SponsorProvider extends ChangeNotifier {
  bool _initialFetched = false;

  List<Sponsor> _sponsors = [];

  List<Sponsor> get sponsors {
    return _sponsors;
  }

  set sponsors(List<Sponsor> newSponsors) {
    _sponsors = newSponsors;
    notifyListeners();
  }

  List<Sponsor> get largeSponsors {
    return sponsors.where((s) => s.mobileSponsor!).toList();
  }

  List<Sponsor> get normalSponsors {
    return sponsors.where((s) => !s.mobileSponsor!).toList();
  }

  Future<void> fetchInitialSponsors() async {
    if (_initialFetched) {
      return;
    }

    var prefs = await SharedPreferences.getInstance();

    sponsors = prefs
            .getStringList(SPONSOR_KEY)
            ?.map((s) => Sponsor.fromJson(json.decode(s)))
            .toList() ??
        [];

    if (sponsors.length > 0) {
      // refresh in background if we found some in storage
      fetchSponsors();
    } else {
      await fetchSponsors();
    }

    _initialFetched = true;
  }

  Future<void> fetchSponsors() async {
    var url = Uri.parse('${Env.methodBaseUrl}/sponsors.json');
    var res = await http.get(url);

    sponsors = (json.decode(res.body)['data'] as List<dynamic>)
        .map((s) => Sponsor.fromJson(s))
        .toList();

    var prefs = await SharedPreferences.getInstance();

    var sponsorsJson = sponsors.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList(SPONSOR_KEY, sponsorsJson);
  }
}
