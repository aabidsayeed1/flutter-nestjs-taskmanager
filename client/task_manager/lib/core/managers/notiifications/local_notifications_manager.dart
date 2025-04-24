// import 'dart:convert';
// import 'dart:math';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:task_manager/app_imports.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:task_manager/route/global_navigator.dart';

// class LocalNotificationManger {
//   //manger
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() async {
//     if (HelperUser.isLoggedIN() && await Permission.notification.status.isGranted) {
//       const InitializationSettings initializationSettings = InitializationSettings(
//         android: AndroidInitializationSettings("ic_notification"),
//         iOS: DarwinInitializationSettings(),
//       );
//       _notificationsPlugin.initialize(
//         initializationSettings,
//         // onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationClick,
//         onDidReceiveNotificationResponse: _onNotificationClick,
//       );
//     }
//   }

//   // Handle background notification click
//   // @pragma('vm:entry-point')
//   // static void _onBackgroundNotificationClick(NotificationResponse details) {
//   //   Utils.printLogs(
//   //       'Firebase listener called when app is in the background (onDidReceiveBackgroundNotificationResponse)');
//   // }

//   // Handle foreground notification click
//   static void _onNotificationClick(NotificationResponse details) {
//     Utils.printLogs(
//       'Firebase listener called when app is in the foreground (onDidReceiveNotificationResponse)',
//     );
//     if (HelperUser.isLoggedIN()) {
//       sl<NavigationService>().navigateToNotification();
//     }
//   }

//   static Future<void> display(RemoteMessage message) async {
//     try {
//       final id = Random().nextInt(100000);
//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           FlavorTypes.appTitle,
//           "channel",
//           importance: Importance.max,
//           priority: Priority.high,
//           icon: 'ic_notification',
//           largeIcon: const DrawableResourceAndroidBitmap("ic_launcher_foreground"),
//           styleInformation: const BigTextStyleInformation(''),
//         ),
//         iOS: const DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       );

//       await _notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: jsonEncode(message.data),
//       );
//     } on Exception catch (e) {
//       Utils.printLogs(e);
//     }
//   }
// }
