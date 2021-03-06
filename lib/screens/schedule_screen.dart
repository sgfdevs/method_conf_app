import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:method_conf_app/widgets/app_banner.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/providers/session_provider.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/session_expansion_tile.dart';
import 'package:method_conf_app/widgets/page_loader.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Future _sessionFuture;

  @override
  void initState() {
    super.initState();

    var sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    _sessionFuture = sessionProvider.fetchInitialSession();
  }

  @override
  Widget build(BuildContext context) {
    var sessionProvider = Provider.of<SessionProvider>(context);

    var eventDate = DateTime.parse(Env.eventDate);
    var dateFormString = 'EEEE, MMMM d\'${daySuffix(eventDate.day)}\', y';

    return AppScreen(
      title: 'Schedule',
      body: PageLoader(
        future: _sessionFuture,
        child: RefreshIndicator(
          onRefresh: () async {
            await sessionProvider.fetchSessions();
          },
          child: ListView(
            padding: EdgeInsets.all(20),
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              ..._buildBanner(eventDate),
              Text(
                DateFormat(dateFormString).format(eventDate),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 15),
              _buildSimpleCard(time: '7:45AM', title: 'Check-in/Breakfast'),
              SizedBox(height: 15),
              _buildSimpleCard(time: '8:45AM', title: 'Welcome Announcement'),
              SizedBox(height: 15),
              Text('Main Track', style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              ..._buildMainSessions(context),
              Text('Workshop Track', style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              ..._buildWorkshopSessions(context),
              Text('Keynote', style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              ..._buildKeynoteSessions(context),
              _buildSimpleCard(time: '5:30PM', title: 'Closing Remarks'),
              SizedBox(height: 15),
              _buildSimpleCard(time: '5:45PM', title: 'After-Party'),
            ],
          ),
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
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  List<Widget> _buildMainSessions(BuildContext context) {
    var sessionProvider = Provider.of<SessionProvider>(context);

    var widgets = <Widget>[];

    for (var session in sessionProvider.mainSessions) {
      widgets.add(SessionExpansionTile(session: session));
      widgets.add(SizedBox(height: 15));
    }

    return widgets;
  }

  List<Widget> _buildWorkshopSessions(BuildContext context) {
    var sessionProvider = Provider.of<SessionProvider>(context);

    var widgets = <Widget>[];

    for (var session in sessionProvider.workshopSessions) {
      widgets.add(SessionExpansionTile(session: session));
      widgets.add(SizedBox(height: 15));
    }

    return widgets;
  }

  List<Widget> _buildKeynoteSessions(BuildContext context) {
    var sessionProvider = Provider.of<SessionProvider>(context);

    var widgets = <Widget>[];

    for (var session in sessionProvider.keynoteSessions) {
      widgets.add(SessionExpansionTile(session: session));
      widgets.add(SizedBox(height: 15));
    }

    return widgets;
  }

  List<Widget> _buildBanner(DateTime eventDate) {
    if(eventDate.isBefore(DateTime.now())) {
      return [Container()];
    }

    return [
      AppBanner(
        text: 'Invest Your Yourself By Honing Your Craft',
        buttonText: 'SEATING IS LIMITED - REGISTER NOW!',
        onButtonPress: () => launchUrl(Env.ticketUrl),
      ),
      SizedBox(height: 20),
    ];
  }
}
