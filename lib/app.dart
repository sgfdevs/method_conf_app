import 'package:flutter/material.dart';
import 'package:method_conf_app/providers/conference_provider.dart';
import 'package:method_conf_app/providers/sponsor_provider_v2.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/providers/session_provider.dart';
import 'package:method_conf_app/providers/speaker_provider.dart';
import 'package:method_conf_app/providers/sponsor_provider.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConferenceProvider()),
        ChangeNotifierProvider(create: (context) => SpeakerProvider()),
        ChangeNotifierProvider(create: (context) {
          var s = Provider.of<SpeakerProvider>(context, listen: false);
          return SessionProvider(speakerProvider: s);
        }),
        ChangeNotifierProvider(create: (context) => SponsorProvider()),
        ChangeNotifierProvider(create: (context) {
          var c = Provider.of<ConferenceProvider>(context, listen: false);
          return SponsorProviderV2(conferenceProvider: c);
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(context),
        home: const AppNavigation(),
      ),
    );
  }
}
