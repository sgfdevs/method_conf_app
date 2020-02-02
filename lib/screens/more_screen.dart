import 'package:flutter/material.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(child: Text('More'),),
        RaisedButton(
          child: Text('Navigate to Nested More'),
          onPressed: () {
            AppNavigator.pushNamed('/more/nested');
          },
        ),
      ],
    );
  }
}

class NestedMoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Nested More'),);
  }
}
