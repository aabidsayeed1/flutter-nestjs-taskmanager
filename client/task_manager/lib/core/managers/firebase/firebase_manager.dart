// import 'package:firebase_core/firebase_core.dart';
// import 'package:task_manager/core/managers/firebase/firebase_fcm_manager.dart';

// // import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class FirebaseManager {
//   static bool bShowed = false;

//   static initialise() async {
//     // We will enable this once firebase is in place
//     await Firebase.initializeApp();
//     FirebaseFCMManger();
//     //FirebaseManager.initDynamicLinks();
//   }

//   // static getInitialLink() async {
//   //   Utils.printLogs("getInitialLink");
//   //   var data = await FirebaseDynamicLinks.instance.getInitialLink();
//   //   Utils.printLogs(data);
//   //   if (data != null) {
//   //     String strLinkData = data.link.toString();
//   //     Utils.printLogs(strLinkData);
//   //   }
//   // }

//   // static initDynamicLinks() {
//   //   Utils.printLogs("initDynamicLinks");
//   //   getInitialLink(); // When app is launched freshly

//   //   // Listener when app is running
//   //   FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData event) {
//   //     Utils.printLogs(event);
//   //     Utils.printLogs(event.link);
//   //   });
//   // }

//   // static bool isShownDeepLinking() {
//   //   return bShowed;
//   // }

//   // static void setIsShownDeepLinking(bool bValue) {
//   //   bShowed = bValue;
//   // }
// }
