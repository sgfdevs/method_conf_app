import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:method_conf_app/models/speaker.dart';
import 'package:method_conf_app/screens/not_found_screen.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class SpeakerDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var speaker = ModalRoute.of(context).settings.arguments as Speaker;

    if (speaker == null) {
      return NotFoundScreen();
    }

    return AppScreen(
      title: 'Speaker',
      body: ListView(
        children: <Widget>[
          Container(
            color: AppColors.neutralExtraLight,
            child: Column(
              children: <Widget>[
                Html(
                  data: """
                      <img src="${speaker.image}" style="float: right">
                      ${speaker.bio}
                    """,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
