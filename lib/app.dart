import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_navigation.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(context),
      home: AppNavigation(),
    );
  }
}
