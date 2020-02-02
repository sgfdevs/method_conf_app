import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_screen.dart';

class SocialFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Happening Now',
      body: Container(
        child: Text('Social Feed'),
      ),
    );
  }
}
