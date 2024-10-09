import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:method_conf_app/theme.dart';
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
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final Map<String, WidgetBuilder> routes = {
    '/schedule': (context) => const ScheduleScreen(),
    '/partners': (context) => const SponsorsScreen(),
    '/more': (context) => const MoreScreen(),
    '/more/speakers': (context) => const SpeakersScreen(),
    '/more/speakers/detail': (context) => const SpeakerDetailScreen(),
    '/more/report': (context) => const ReportScreen(),
    '/more/report/success': (context) => const ReportSuccessScreen(),
    '/more/feedback': (context) => const SessionFeedbackScreen(),
    '/more/feedback/success': (context) => const SessionFeedbackSuccessScreen(),
  };

  List<_NavigationItem> get navigationItems {
    return [
      _NavigationItem(
        route: '/schedule',
        item: _buildNavigationBarItem(FontAwesomeIcons.calendar, 'Schedule'),
      ),
      _NavigationItem(
        route: '/partners',
        item: _buildNavigationBarItem(FontAwesomeIcons.piggyBank, 'Sponsors'),
      ),
      _NavigationItem(
        route: '/more',
        item: _buildNavigationBarItem(FontAwesomeIcons.ellipsis, 'More'),
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
        notFoundBuilder: (context) => const NotFoundScreen(),
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
          unselectedItemColor: AppColors.neutral,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String text) {
    return BottomNavigationBarItem(
      icon: FaIcon(icon, size: 25),
      label: text,
    );
  }

  void _onItemTapped(int value) {
    if (value == _selectedIndex) {
      return;
    }

    AppNavigator.pushNamed(navigationItems[value].route);
  }

  void _updateTabIndexOnRouteChange(Route? newRoute) {
    var routes = navigationItems.map((i) => i.route).toList();
    var newIndex = 0;

    for (var index in Iterable<int>.generate(routes.length)) {
      var route = routes[index];

      if (newRoute?.settings.name?.startsWith(route) ?? false) {
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

  _NavigationItem({required this.route, required this.item});
}
