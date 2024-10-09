import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:method_conf_app/data/umbraco/models/session.dart';
import 'package:method_conf_app/data/umbraco/models/track.dart';
import 'package:method_conf_app/providers/schedule_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _startColumnIndexStorageKey = 'app-schedule-start-column-index';

class ScheduleStateProvider extends ChangeNotifier {
  ScheduleProvider scheduleProvider;

  int _visibleColumns = 1;

  int get visibleColumns => _visibleColumns;

  set visibleColumns(int value) {
    _visibleColumns = value;
    notifyListeners();
  }

  int _startColumnIndex = 0;

  int get currentColumnIndex => _startColumnIndex;

  set currentColumnIndex(int value) {
    _startColumnIndex = value;
    notifyListeners();
    store(_startColumnIndex);
  }

  int get _totalColumns =>
      scheduleProvider.grid.elementAtOrNull(0)?.length ?? 0;
  int get _maxStartIndex => max(_totalColumns - visibleColumns, 0);

  bool get isNextEnabled => currentColumnIndex < _maxStartIndex;
  bool get isPrevEnabled => currentColumnIndex != 0;

  ScheduleStateProvider({required this.scheduleProvider});

  Future<void> init() async {
    final storedStartColumnIndex = await load();

    if (storedStartColumnIndex != null) {
      currentColumnIndex = storedStartColumnIndex;
    }
  }

  Future<int?> load() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_startColumnIndexStorageKey);
  }

  Future<void> store(int? newStartColumnIndex) async {
    var prefs = await SharedPreferences.getInstance();

    if (newStartColumnIndex == null) {
      await prefs.remove(_startColumnIndexStorageKey);
      return;
    }

    await prefs.setInt(_startColumnIndexStorageKey, newStartColumnIndex);
  }

  Track? getTrackAtColumn(int column) {
    return scheduleProvider.tracks.elementAtOrNull(column);
  }

  List<Session> getSessionsAtColumn(int column) {
    return scheduleProvider.grid
        .map((row) => row.elementAtOrNull(column))
        .toSet()
        .whereType<String>()
        .map((gridId) => scheduleProvider.sessions
            .firstWhereOrNull((session) => session.gridId == gridId))
        .whereType<Session>()
        .toList();
  }
}

enum ControlDirection {
  prev,
  next,
}
