import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';

class CustomNavigator {
  // Pushes to the route specified
  static pushTo(BuildContext context, String strPageName, {var arguments}) async {
    Utils.printLogs("arguments $arguments");

    var result = await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(strPageName, arguments: arguments);
    return result;
  }

  // Pop the top view
  static pop(BuildContext context, {var result}) {
    Navigator.pop(context, result);
  }

  // Pops to a particular view
  static popTo(BuildContext context, String strPageName) {
    Navigator.popAndPushNamed(context, strPageName);
  }

  static popUntilFirstAndPush(BuildContext context, String strPageName) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, strPageName);
  }

  static popUntilFirstAndPushNamed(BuildContext context, String strPageName) {
    Navigator.pushNamedAndRemoveUntil(context, strPageName, (route) => route.isFirst);
  }

  static pushReplace(BuildContext context, String strPageName, {var arguments}) {
    Navigator.pushReplacementNamed(context, strPageName, arguments: arguments);
  }

  static pushNamedAndRemoveAll(BuildContext context, String strPageName, {var arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, strPageName, (route) => false, arguments: arguments);
  }

  // Get current route name
  static String? getCurrentRouteName(BuildContext context) {
    final route = ModalRoute.of(context);
    return route?.settings.name;
  }

  // just to check if page is in the stack but not remove it
  // static bool isPageInStack(BuildContext context, String pageRoute) {
  //   bool bFound = false;

  //   Navigator.popUntil(context, (route) {
  //     if (route.settings.name == pageRoute) {
  //       bFound = true;
  //     }
  //     return true; // Don't pop, just iterate
  //   });

  //   return bFound;
  // }
}
