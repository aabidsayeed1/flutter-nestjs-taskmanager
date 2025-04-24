import 'package:flutter/material.dart';
import 'package:task_manager/features/tasks/presentation/pages/recycle_bin.dart';
import 'package:task_manager/features/tasks/presentation/pages/dashboard_page.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RecycleBinPage.id:
        return MaterialPageRoute(builder: (_) => const RecycleBinPage());
      case DashBoardPage.id:
        return MaterialPageRoute(builder: (_) => DashBoardPage());
      default:
        return null;
    }
  }
}
