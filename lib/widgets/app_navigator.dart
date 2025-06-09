import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:method_conf_app/utils/analytics.dart';
import 'package:plausible_analytics/navigator_observer.dart';

class AppNavigator extends StatelessWidget {
  static var analyticsObserver = PlausibleNavigatorObserver(analytics);
  static final _navigatorKey = GlobalKey<NavigatorState>();

  final RouteChangeCallBack? onRouteChange;
  final Map<String, WidgetBuilder> routes;
  final String initialRoute;
  final WidgetBuilder notFoundBuilder;

  const AppNavigator({
    super.key,
    required this.routes,
    required this.initialRoute,
    required this.notFoundBuilder,
    this.onRouteChange,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        if (_navigatorKey.currentState!.canPop()) {
          _navigatorKey.currentState!.pop();
          return;
        }
      },
      child: Navigator(
        key: _navigatorKey,
        initialRoute: initialRoute,
        observers: [
          _AppNavigationObserver(onRouteChange: _onRouteChangeHandler),
          analyticsObserver,
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

  void _onRouteChangeHandler(Route? newRoute) {
    if (onRouteChange == null) {
      return;
    }

    // Wait for widget tree to build before running callback
    // This allows the callback to safely use setState
    SchedulerBinding.instance.addPersistentFrameCallback((_) {
      onRouteChange!(newRoute);
    });
  }

  static Future<T?> pushNamed<T extends Object>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static void pop<T extends Object>([T? result]) {
    return _navigatorKey.currentState!.pop<T>(result);
  }

  static Future<T?> pushReplacementNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }
}

typedef RouteChangeCallBack = void Function(Route? newRoute);

class _AppNavigationObserver extends NavigatorObserver {
  final RouteChangeCallBack onRouteChange;

  _AppNavigationObserver({required this.onRouteChange});

  @override
  void didPush(Route route, Route? previousRoute) {
    onRouteChange(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    onRouteChange(previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    onRouteChange(newRoute);
  }
}
