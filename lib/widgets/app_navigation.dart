import 'package:flutter/material.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/app_icons.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:method_conf_app/screens/more_screen.dart';
import 'package:method_conf_app/screens/not_found_screen.dart';
import 'package:method_conf_app/screens/sponsors_screen.dart';
import 'package:method_conf_app/screens/schedule_screen.dart';
import 'package:method_conf_app/screens/speakers_screen.dart';
import 'package:method_conf_app/screens/report_screen.dart';
import 'package:method_conf_app/screens/report_success_screen.dart';
import 'package:method_conf_app/screens/speaker_detail_screen.dart';
import 'package:method_conf_app/screens/session_feedback_screen.dart';
import 'package:method_conf_app/screens/session_feedback_success_screen.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final Map<String, WidgetBuilder> routes = {
    '/schedule': (context) => ScheduleScreen(),
    '/partners': (context) => SponsorsScreen(),
    '/more': (context) => MoreScreen(),
    '/more/speakers': (context) => SpeakersScreen(),
    '/more/speakers/detail': (context) => SpeakerDetailScreen(),
    '/more/report': (context) => ReportScreen(),
    '/more/report/success': (context) => ReportSuccessScreen(),
    '/more/feedback': (context) => SessionFeedbackScreen(),
    '/more/feedback/success': (context) => SessionFeedbackSuccessScreen(),
  };


  List<_NavigationItem> get navigationItems {
    return [
      _NavigationItem(
        route: '/schedule',
        item: _buildNavigationBarItem(AppIcons.schedule, 'Schedule'),
      ),
      _NavigationItem(
        route: '/partners',
        item: _buildNavigationBarItem(AppIcons.piggy_bank, 'Partners'),
      ),
      _NavigationItem(
        route: '/more',
        item: _buildNavigationBarItem(Icons.more_horiz, 'More'),
      ),
    ];
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppNavigator(
        initialRoute: '/schedule',
        routes: routes,
        notFoundBuilder: (context) => NotFoundScreen(),
        onRouteChange: _updateTabIndexOnRouteChange,
      ),
      bottomNavigationBar: Container(
        color: AppColors.primary,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          items: navigationItems.map((i) => i.item).toList(),
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.primaryLight,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String text) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 25),
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _onItemTapped(int value) {
    if(value == _selectedIndex) {
      return;
    }

    AppNavigator.pushNamed(navigationItems[value].route);
  }

  void _updateTabIndexOnRouteChange(Route newRoute) {
    var routes = navigationItems.map((i) => i.route).toList();
    var newIndex = 0;

    for (var index in Iterable<int>.generate(routes.length)) {
      var route = routes[index];

      if (newRoute.settings.name.startsWith(route)) {
        newIndex = index;
        break;
      }
    }

    setState(() {
      _selectedIndex = newIndex;
    });
  }
}

class _NavigationItem {
  final String route;
  final BottomNavigationBarItem item;

  _NavigationItem({this.route, this.item});
}
