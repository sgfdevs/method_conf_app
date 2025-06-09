import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:method_conf_app/data/get_default_conference.dart';
import 'package:method_conf_app/data/umbraco/models/conference.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _defaultConferenceStorageKey = 'app-default-conference';

class ConferenceProvider extends ChangeNotifier {
  Conference? _conference;

  Conference? get conference => _conference;

  set conference(Conference? newConference) {
    _conference = newConference;
    notifyListeners();
  }

  Future<void> init({bool enableBackgroundRefresh = true}) async {
    conference ??= await load();

    if (conference == null) {
      await refresh();
    } else if (enableBackgroundRefresh) {
      refresh();
    }
  }

  Future<Conference?> load() async {
    var prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_defaultConferenceStorageKey);
    return jsonString != null
        ? Conference.fromJson(json.decode(jsonString))
        : null;
  }

  Future<void> store(Conference? newConference) async {
    var prefs = await SharedPreferences.getInstance();

    if (newConference == null) {
      await prefs.remove(_defaultConferenceStorageKey);
      return;
    }

    await prefs.setString(
      _defaultConferenceStorageKey,
      json.encode(newConference.toJson()),
    );
  }

  Future<Conference?> fetch() async {
    return await getDefaultConference();
  }

  Future<void> refresh() async {
    final newConference = await fetch();

    conference = newConference;

    await store(newConference);
  }
}
