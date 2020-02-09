import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppNavigator extends StatelessWidget {
  static final _navigatorKey = GlobalKey<NavigatorState>();
  final _RouteChangeCallBack onRouteChange;
  final Map<String, WidgetBuilder> routes;
  final String initialRoute;
  final WidgetBuilder notFoundBuilder;

  AppNavigator({
    Key key,
    @required this.routes,
    @required this.initialRoute,
    @required this.notFoundBuilder,
    this.onRouteChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState.canPop()) {
          _navigatorKey.currentState.pop();
          return false;
        }

        return true;
      },
      child: Navigator(
        key: _navigatorKey,
        initialRoute: initialRoute,
        observers: [
          _AppNavigationObserver(onRouteChange: _onRouteChangeHandler)
        ],
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: notFoundBuilder,
            settings: settings,
            maintainState: false,
          );
        },
        onGenerateRoute: (settings) {
          var builder = routes[settings.name];

          if (builder == null) {
            return null;
          }

          return MaterialPageRoute(
            builder: builder,
            settings: settings,
            maintainState: false,
          );
        },
      ),
    );
  }

  void _onRouteChangeHandler(Route newRoute) {
    if (onRouteChange == null) {
      return;
    }

    // Wait for widget tree to build before running callback
    // This allows the callback to safely use setState
    SchedulerBinding.instance.addPersistentFrameCallback((_) {
      onRouteChange(newRoute);
    });
  }

  static Future<T> pushNamed<T extends Object>(String routeName,
      {Object arguments}) {
    return _navigatorKey.currentState
        .pushNamed<T>(routeName, arguments: arguments);
  }

  static bool pop<T extends Object>([T result]) {
    return _navigatorKey.currentState.pop<T>(result);
  }

  static Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
  }) {
    return _navigatorKey.currentState.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }
}

typedef _RouteChangeCallBack = void Function(Route newRoute);

class _AppNavigationObserver extends NavigatorObserver {
  final _RouteChangeCallBack onRouteChange;

  _AppNavigationObserver({@required this.onRouteChange});

  @override
  void didPush(Route route, Route previousRoute) {
    onRouteChange(route);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    onRouteChange(previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    onRouteChange(newRoute);
  }
}
