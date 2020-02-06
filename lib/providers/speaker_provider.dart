import 'package:flutter/material.dart';

import 'package:method_conf_app/models/speaker.dart';

class SpeakerProvider extends ChangeNotifier {
  List<Speaker> _speakers = [];


  List<Speaker> get speakers {
    return _speakers;
  }

  set speakers(List<Speaker> newSpeakers) {
    _speakers = newSpeakers;
    notifyListeners();
  }
}