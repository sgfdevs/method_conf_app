import 'package:flutter/material.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';

import 'package:method_conf_app/widgets/app_screen.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'More ...',
      body: Column(
        children: <Widget>[
          Container(
              child: RaisedButton(
            child: Text('more'),
            onPressed: () {
              AppNavigator.pushNamed('/more/nested');
            },
          )),
        ],
      ),
    );
  }
}

class NestedMoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Nested More ...',
      body: Column(
        children: <Widget>[
          Container(child: Text('More')),
        ],
      ),
    );
  }
}
