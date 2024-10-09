import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:method_conf_app/data/get_schedule_grid.dart';
import 'package:method_conf_app/data/get_schedule_items.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_model_base.dart';
import 'package:method_conf_app/data/umbraco/models/session.dart';
import 'package:method_conf_app/data/umbraco/models/speaker.dart';
import 'package:method_conf_app/data/umbraco/models/track.dart';
import 'package:method_conf_app/providers/conference_provider.dart';
import 'package:method_conf_app/utils/iterable_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _scheduleItemsStorageKey = 'app-schedule-items';
const _scheduleGridStorageKey = 'app-schedule-grid';

typedef Schedule = (List<ApiContentModelBase>, List<List<String?>>);

class ScheduleProvider extends ChangeNotifier {
  ConferenceProvider conferenceProvider;

  Schedule? _schedule;

  Schedule? get schedule => _schedule;

  set schedule(Schedule? value) {
    _schedule = value;
    notifyListeners();
  }

  List<List<String?>> get grid => schedule?.$2 ?? [];

  List<int> get columns =>
      grid
          .elementAtOrNull(0)
          ?.asMap()
          .entries
          .map((entry) => entry.key)
          .toList() ??
      [];

  List<Track> get tracks => schedule?.$1.whereType<Track>().toList() ?? [];

  List<Session> get sessions =>
      schedule?.$1.whereType<Session>().toList() ?? [];

  List<Speaker> get speakers => sessions
      .expand((session) => session.properties?.speakers ?? <Speaker>[])
      .distinctBy((speaker) => speaker.id)
      .toList();

  ScheduleProvider({required this.conferenceProvider});

  Future<void> init() async {
    await conferenceProvider.init(enableBackgroundRefresh: false);

    schedule ??= await load();

    if (schedule == null) {
      await refresh();
    } else {
      refresh();
    }
  }

  Future<Schedule?> load() async {
    var prefs = await SharedPreferences.getInstance();

    final itemsJson = prefs.getStringList(_scheduleItemsStorageKey);
    final gridJson = prefs.getStringList(_scheduleGridStorageKey);

    final items = itemsJson
        ?.map((item) => ApiContentModelBase.fromJson(json.decode(item)))
        .toList();

    final grid = gridJson
        ?.map((row) => (json.decode(row) as List<dynamic>)
            .map((item) => item as String?)
            .toList())
        .toList();

    if (items == null || grid == null) {
      return null;
    }

    return (items, grid);
  }

  Future<void> store(Schedule? newSchedule) async {
    var prefs = await SharedPreferences.getInstance();

    if (newSchedule == null) {
      await Future.wait([
        prefs.remove(_scheduleItemsStorageKey),
        prefs.remove(_scheduleGridStorageKey),
      ]);
      return;
    }

    final (items, grid) = newSchedule;

    await Future.wait([
      prefs.setStringList(
        _scheduleItemsStorageKey,
        items.map((item) => json.encode(item.toJson())).toList(),
      ),
      prefs.setStringList(
        _scheduleGridStorageKey,
        grid.map((item) => json.encode(item)).toList(),
      ),
    ]);
  }

  Future<Schedule?> fetch() async {
    var conference = conferenceProvider.conference;

    if (conference == null) {
      return null;
    }

    final itemsFuture = getScheduleItems(conference.id);
    final gridFuture = getScheduleGrid(conference.id);

    final items = await itemsFuture;
    final grid = await gridFuture;

    return (items, grid);
  }

  Future<void> refresh() async {
    final newSchedule = await fetch();

    schedule = newSchedule;

    await store(newSchedule);
  }

  List<Session> getSessionsForSpeaker(Speaker? speaker) {
    if (speaker == null) {
      return [];
    }

    return sessions
        .where(
          (session) =>
              session.properties?.speakers.firstWhereOrNull(
                  (sessionSpeaker) => sessionSpeaker.id == speaker.id) !=
              null,
        )
        .toList();
  }
}
