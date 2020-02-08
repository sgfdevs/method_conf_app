import 'package:flutter/material.dart';
import 'package:method_conf_app/models/session.dart';

import 'package:method_conf_app/models/speaker.dart';

class SpeakerProvider extends ChangeNotifier {
  List<Speaker> _speakers = [];

  List<Speaker> get speakers => _speakers;

  set speakers(List<Speaker> newSpeakers) {
    _speakers = newSpeakers;
    notifyListeners();
  }

  Speaker getSpeakerByName(String name) {
    return speakers.firstWhere(
      (s) => s.name == name,
      orElse: null,
    );
  }

  // Uses the speakers name as a key to ensure no duplicate speakers
  void setSpeakersFromSessions(List<Session> sessions) {
    var speakersByName = <String, Speaker>{};

    for (final session in sessions) {
      speakersByName[session.speaker.name] = session.speaker;
    }

    speakers = speakersByName.values.toList();
  }
}
