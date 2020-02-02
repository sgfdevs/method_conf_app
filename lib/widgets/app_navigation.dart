import 'package:flutter/material.dart';

import 'package:method_conf_app/screens/more_screen.dart';
import 'package:method_conf_app/screens/not_found_screen.dart';
import 'package:method_conf_app/screens/partners_screen.dart';
import 'package:method_conf_app/screens/schedule_screen.dart';
import 'package:method_conf_app/screens/social_feed_screen.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';

Map<String, WidgetBuilder> routes = {
  '/schedule': (context) => ScheduleScreen(),
  '/social-feed': (context) => SocialFeedScreen(),
  '/partners': (context) => PartnersScreen(),
  '/more': (context) => MoreScreen(),
  '/more/nested': (context) => NestedMoreScreen(),
};

var navigationItems  = [
  _NavigationItem(
    route: '/schedule',
    item: BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Schedule'),
    ),
  ),
  _NavigationItem(
    route: '/social-feed',
    item: BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('MethodConf'),
    ),
  ),
  _NavigationItem(
    route: '/partners',
    item: BottomNavigationBarItem(
      icon: Icon(Icons.school),
      title: Text('Partners'),
    ),
  ),
  _NavigationItem(
    route: '/more',
    item: BottomNavigationBarItem(
      icon: Icon(Icons.details),
      title: Text('More'),
    ),
  ),
];


class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppNavigator(
          initialRoute: '/schedule',
          routes: routes,
          notFoundBuilder: (context) => NotFoundScreen(),
          onRouteChange: _updateTabIndexOnRouteChange,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: navigationItems.map((i) => i.item).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int value) {
    AppNavigator.pushNamed(navigationItems[value].route);
  }

  void _updateTabIndexOnRouteChange(Route newRoute) {
    if(!mounted) {
      return;
    }

    var routes = navigationItems.map((i) => i.route).toList();
    var newIndex = 0;

    for (var index in Iterable<int>.generate(routes.length)) {
      var route = routes[index];

      if(newRoute.settings.name.startsWith(route)) {
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
