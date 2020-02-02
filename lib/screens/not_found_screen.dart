import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_screen.dart';

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Not Found',
      body: Container(
        child: Text('Not Found'),
      ),
    );
  }
}
