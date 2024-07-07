import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class SessionFeedbackSuccessScreen extends StatelessWidget {
  const SessionFeedbackSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Session Feedback',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const <Widget>[
          Text(
            'Your Feedback Has Been Sent',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          AppHtml(
            markup: "Thanks for taking a moment and providing your feedback.",
          ),
        ],
      ),
    );
  }
}
