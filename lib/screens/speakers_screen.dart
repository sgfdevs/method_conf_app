import 'package:flutter/material.dart';
import 'package:method_conf_app/widgets/app_list_item.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/providers/speaker_provider.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class SpeakersScreen extends StatelessWidget {
  const SpeakersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var speakersProvider = Provider.of<SpeakerProvider>(context);

    return AppScreen(
        title: 'Speakers',
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            ...speakersProvider.speakers.map((speaker) {
              return AppListItem(
                text: speaker.name,
                onTap: () {
                  AppNavigator.pushNamed(
                    '/more/speakers/detail',
                    arguments: speaker,
                  );
                },
              );
            }),
          ],
        ));
  }
}
