import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_screen.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'More ...',
      body: Column(
        children: <Widget>[
          Container(child: Text('More')),
        ],
      ),
    );
  }
}
