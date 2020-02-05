import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/session_expansion_tile.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var eventDate = DateTime.parse(DotEnv().env['EVENT_DATE']);
    var dateFormString = 'EEEE, MMMM d\'${daySuffix(eventDate.day)}\', y';

    return AppScreen(
      title: 'Schedule',
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        child: ListView(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Text(
              DateFormat(dateFormString).format(eventDate),
              style: TextStyle(fontSize: 24),
            ),
            _buildSimpleCard(time: '7:45AM', title: 'Check-in/Breakfast'),
            _buildSimpleCard(time: '8:45AM', title: 'Welcome Announcement'),
            SessionExpansionTile(),
            SessionExpansionTile(),
            SessionExpansionTile(),
            SessionExpansionTile(),
            _buildSimpleCard(time: '5:30PM', title: 'Closing Remarks'),
            _buildSimpleCard(time: '5:45PM', title: 'After-Party'),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleCard({String time, String title}) {
    return Container(
      color: AppColors.neutralExtraLight,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text(
            time,
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
