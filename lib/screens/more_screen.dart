import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(child: Text('More'),),
        Text('Navigate to Nested More'),
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
