import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/providers/session_provider.dart';
import 'package:method_conf_app/providers/speaker_provider.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_navigation.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => SpeakerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(context),
        home: AppNavigation(),
      ),
    );
  }
}
