import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_screen.dart';

class SpeakersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Speakers',
      body: Container(
        child: Text('Speakers'),
      ),
    );
  }
}
