import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/app_list_item.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'More ...',
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          AppListItem(text: 'Location Info'),
          AppListItem(text: 'Floorplan'),
          AppListItem(text: 'Code of Conduct'),
          AppListItem(
            text: 'Tickets',
            onTap: () => launchUrl(DotEnv().env['TICKET_URL']),
          ),
          AppListItem(
            text: 'Speakers',
            onTap: () => AppNavigator.pushNamed('/more/speakers'),
          ),
          AppListItem(text: 'Report Issue'),
        ],
      ),
    );
  }
}
