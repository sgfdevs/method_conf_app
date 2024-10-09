import 'package:flutter/material.dart';

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/app_list_item.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'More ...',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          AppListItem(
            text: 'Location Info',
            onTap: () => launchUrl('${Env.methodBaseUrl}/2024/#location'),
          ),
//          AppListItem(text: 'Floorplan'),
          AppListItem(
            text: 'Code of Conduct',
            onTap: () => launchUrl('${Env.methodBaseUrl}/2024/code-of-conduct'),
          ),
          AppListItem(
            text: 'Tickets',
            onTap: () => launchUrl('${Env.methodBaseUrl}/register'),
          ),
          AppListItem(
            text: 'Speakers',
            onTap: () => AppNavigator.pushNamed('/more/speakers'),
          ),
          AppListItem(
            text: 'Report Issue',
            onTap: () => AppNavigator.pushNamed('/more/report'),
          ),
        ],
      ),
    );
  }
}
