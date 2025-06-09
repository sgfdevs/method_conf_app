import 'package:flutter/material.dart';
import 'package:method_conf_app/providers/conference_provider.dart';
import 'package:method_conf_app/providers/schedule_provider.dart';
import 'package:method_conf_app/providers/schedule_state_provider.dart';
import 'package:method_conf_app/providers/sponsor_provider.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConferenceProvider()),
        ChangeNotifierProvider(
          create: (context) {
            var c = Provider.of<ConferenceProvider>(context, listen: false);
            return SponsorProvider(conferenceProvider: c);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            var c = Provider.of<ConferenceProvider>(context, listen: false);
            return ScheduleProvider(conferenceProvider: c);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            var s = Provider.of<ScheduleProvider>(context, listen: false);
            return ScheduleStateProvider(scheduleProvider: s);
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(context),
        home: const AppNavigation(),
      ),
    );
  }
}
