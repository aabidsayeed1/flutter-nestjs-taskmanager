import 'package:task_manager/core/helpers/helper_user.dart';
import 'package:task_manager/route/app_pages.dart';
import 'package:task_manager/route/custom_navigator.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Future<dynamic> navigateTo(RemoteMessage message) {
  //   if (!HelperUser.isLoggedIN()) {
  //     return CustomNavigator.pushReplace(
  //         navigatorKey.currentState!.context, AppPages.PAGE_LOGIN);
  //   }

  //   // this is unitl we handle the navigation
  //   return CustomNavigator.pushReplace(
  //       navigatorKey.currentState!.context, AppPages.PAGE_LOGIN);
  // }

  Future<dynamic> navigateThroughLocalNotificationClick(var message) {
    if (!HelperUser.isLoggedIN()) {
      return CustomNavigator.pushReplace(navigatorKey.currentState!.context, AppPages.PAGE_LOGIN);
    }

    // this is unitl we handle the navigation
    return CustomNavigator.pushReplace(navigatorKey.currentState!.context, AppPages.PAGE_LOGIN);
  }

  Future<dynamic> navigateToLogin() async {
    return await CustomNavigator.pushNamedAndRemoveAll(
      navigatorKey.currentState!.context,
      AppPages.PAGE_DASHBOARD,
    );
  }
}
