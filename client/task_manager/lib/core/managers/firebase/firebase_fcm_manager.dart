// import 'package:permission_handler/permission_handler.dart';
// import 'package:task_manager/app_imports.dart';
// import 'package:task_manager/core/apis/fcmToken/send_fcm_token.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:task_manager/route/global_navigator.dart';

// class FirebaseFCMManger {
//   static FirebaseFCMManger? _instance;
//   static late FirebaseMessaging _messaging;
//   RemoteMessage? _pendingMessage;

//   FirebaseFCMManger._internal(String? id) {
//     _instance = this;
//     _instance!.registerNotification(id: id);
//   }

//   factory FirebaseFCMManger({String? id}) => _instance ?? FirebaseFCMManger._internal(id);

//   void registerNotification({String? id}) async {
//     // This helps to take the user permissions
//     if (HelperUser.isLoggedIN() && await Permission.notification.status.isGranted) {
//       // Instantiate Firebase Messaging
//       _messaging = FirebaseMessaging.instance;
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         provisional: false,
//         sound: true,
//       );

//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         Utils.printLogs('User granted permission');
//         LocalNotificationManger.initialize();
//         FirebaseMessaging.instance.getInitialMessage().then((message) {
//           Utils.printLogs('Firebase listener called when clicked ${message.toString()}');

//           if (message != null) {
//             Utils.printLogs(message);
//             onInitialMessge(message);
//           }
//         });

//         //forground notification
//         FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//           fcmOnForeground(message);
//         });

//         FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//           fcmOnBackground(message);
//         });
//       } else {
//         Utils.printLogs('User declined or has not accepted permission');
//       }
//     }
//   }

//   void sendFcmToken({bool bIsAfterLogin = false}) {
//     // Check if the token is already generated for this user
//     String strToken = SharedPreferencesManager.getString(AppStrings.STRING_KEY_FCMTOKEN);

//     // If token present, just fire the callbacks for receiving messages
//     if (strToken.isEmpty || bIsAfterLogin) {
//       FirebaseMessaging.instance.getToken().then((strFCMToken) async {
//         if (strFCMToken != null && strFCMToken.isNotEmpty) {
//           Utils.printLogs(strFCMToken);
//           String? strToken = await SendFcmTokenDataSource().sendFcmtoken(strFcmToken: strFCMToken);
//           if (strToken != null && strToken.isNotEmpty) {
//             SharedPreferencesManager.setString(AppStrings.STRING_KEY_FCMTOKEN, strToken);
//           }
//         }
//       });
//     }
//   }

//   void onInitialMessge(RemoteMessage message) async {
//     Utils.printLogs('Firebase listener called when clicked');
//     _pendingMessage = message;
//   }

//   void handlePendingNotification() {
//     if (_pendingMessage != null) {
//       Utils.printLogs('Processing pending notification after app is initialized');
//       sl<NavigationService>().navigateToNotification();
//       _pendingMessage = null;
//     }
//   }

//   void fcmOnForeground(RemoteMessage message) async {
//     Utils.printLogs('Firebase listener called when app is in the foreground');
//     await LocalNotificationManger.display(message);
//   }

//   void fcmOnBackground(RemoteMessage message) {
//     Utils.printLogs('Firebase listener called from bg to fg');
//     if (HelperUser.isLoggedIN()) {
//       sl<NavigationService>().navigateToNotification();
//     }
//   }
// }
