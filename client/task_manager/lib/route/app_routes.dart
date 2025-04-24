import 'package:flutter/material.dart';
import 'package:task_manager/core/managers/general/app_update_manager.dart';
import 'package:task_manager/features/login/presentation/pages/login_page.dart';
import 'package:task_manager/features/login/presentation/pages/otp_verify_page.dart';
import 'package:task_manager/features/tasks/presentation/pages/recycle_bin.dart';
import 'package:task_manager/features/tasks/presentation/pages/dashboard_page.dart';
import 'package:task_manager/route/app_pages.dart';

Route<dynamic> controller(RouteSettings settings) {
  return AppUpdateManager.instance.validateFeatureForceUpdate(settings, switch (settings.name) {
    // AppPages.PAGE_APP_ENTRY => MaterialPageRoute(builder: (context) => const AppEntryWidget()),
    // AppPages.PAGE_LOGIN => MaterialPageRoute(builder: (context) => const LoginPage()),
    AppPages.PAGE_DASHBOARD => MaterialPageRoute(builder: (context) => const DashBoardPage()),
    AppPages.PAGE_RECYCLE_BIN => MaterialPageRoute(builder: (context) => const RecycleBinPage()),
    AppPages.PAGE_LOGIN => MaterialPageRoute(builder: (context) => const LoginPage()),
    AppPages.PAGE_OTP_VERIFY => MaterialPageRoute(
      builder: (context) {
        final data = settings.arguments as Map<String, dynamic>? ?? {};
        final phoneNumber = data['mobile'] ?? "";
        return OTPVerifyPage(phoneNumber: phoneNumber);
      },
    ),

    _ => MaterialPageRoute(
      builder: (context) => const Scaffold(body: Text('This route name does not exist')),
    ),
  });
}
