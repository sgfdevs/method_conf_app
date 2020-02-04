import 'package:flutter/material.dart';
import 'package:method_conf_app/widgets/session_expansion_tile.dart';

import 'package:method_conf_app/widgets/app_screen.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Schedule',
      body: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SessionExpansionTile(),
            ),
          ),
        ],
      ),
    );
  }
}
