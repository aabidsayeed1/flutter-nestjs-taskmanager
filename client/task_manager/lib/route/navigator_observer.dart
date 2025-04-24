import 'package:flutter/material.dart';
import 'package:task_manager/core/helpers/utils.dart';

class AppNavigatorObserver extends NavigatorObserver {
  static String? strCurrentRouteName;

  // Get current route name
  static String? getCurrentRouteName() {
    return strCurrentRouteName;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    strCurrentRouteName = route.settings.name;
    Utils.printLogs('Pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    strCurrentRouteName = previousRoute?.settings.name;
    Utils.printLogs('Popped to: ${previousRoute?.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    strCurrentRouteName = newRoute?.settings.name;
    Utils.printLogs('Replaced with: $strCurrentRouteName');
  }

  // Note: We can extend others also as needed, Currently I wanted to know if i am on dashboard or not. So, just added these functions
}
