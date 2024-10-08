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

  int startColumnIndex = 0;

  Key get currentKey => ValueKey(startColumnIndex);

  Track? get currentTrack =>
      scheduleProvider.tracks.elementAtOrNull(startColumnIndex);

  List<Session> get currentSessions => scheduleProvider.grid
      .map((row) => row.elementAtOrNull(startColumnIndex))
      .toSet()
      .whereType<String>()
      .map((gridId) => scheduleProvider.sessions
          .firstWhereOrNull((session) => session.gridId == gridId))
      .whereType<Session>()
      .toList();

  int get _totalColumns =>
      scheduleProvider.grid.elementAtOrNull(0)?.length ?? 0;
  int get _maxStartIndex => max(_totalColumns - visibleColumns, 0);

  bool get isNextEnabled => startColumnIndex < _maxStartIndex;
  bool get isPrevEnabled => startColumnIndex != 0;

  ScheduleStateProvider({required this.scheduleProvider});

  Future<void> init() async {
    final storedStartColumnIndex = await load();

    if (storedStartColumnIndex != null) {
      startColumnIndex = storedStartColumnIndex;
      notifyListeners();
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

  Future handleControl(ControlDirection direction) async {
    final prevIndex = startColumnIndex;
    if (direction == ControlDirection.next) {
      startColumnIndex = min(prevIndex + 1, _maxStartIndex);
    } else {
      startColumnIndex = max(prevIndex - 1, 0);
    }

    await store(startColumnIndex).catchError((err) {
      print(err);
    });
    notifyListeners();
  }
}

enum ControlDirection {
  prev,
  next,
}
