import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class ReportSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Issue Reported',
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Your Message Has Been Sent',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          AppHtml(
            markup:
                "If you provided an email or phone number we'll be in touch shortly.",
          ),
          SizedBox(height: 20),
          AppHtml(
            markup: """
              <strong>I’m still pissed what else can I do?</strong>
              <br>
              Text Shawna Baron at <a href="tel:4178949926">417-894-9926</a>. Locate a conference organizer or volunteer, who are recognizable by their badges/t-shirts (or as otherwise explained by organizers at the beginning of the conference). In an emergency, please call 911.
              """,
          ),
        ],
      ),
    );
  }
}
