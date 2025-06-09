import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class ReportSuccessScreen extends StatelessWidget {
  const ReportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    final responseMessage = arguments is String ? arguments : null;

    return AppScreen(
      title: 'Issue Reported',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your Message Has Been Sent',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (responseMessage != null) AppHtml(markup: responseMessage),
        ],
      ),
    );
  }
}
