import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(context),
        home: Container(),
      ),
    );
  }
}
