

// import 'dart:isolate';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';

// class FirebaseCrashlyticsManager {
//    // Just for testing
//   static simualteCrash() {
//     FirebaseCrashlytics.instance.crash();
//   }

//   static addLog(String strMessage) {
//     FirebaseCrashlytics.instance.log(strMessage);
//   }

//   static setUserIdentifier(String strUserId) {
//     FirebaseCrashlytics.instance.setUserIdentifier(strUserId);
//   }
//   static reportError(exception, stackTrace) {
//     // Pass all uncaught errors from the framework to Crashlytics
//      FirebaseCrashlytics.instance.recordError(exception, stackTrace);
//   }

//   // Errors to be caught ouside the flutter context
//   static reportErrorListener() {
//     Isolate.current.addErrorListener(RawReceivePort((pair) async {
//     final List<dynamic> errorAndStacktrace = pair;
//       FirebaseCrashlyticsManager.reportError(errorAndStacktrace.first, errorAndStacktrace.last);
//     }).sendPort);
//   }

//   static enableCrashlytics() async{
//     if(kDebugMode) {
//       // Debug mode - Force disable Crashlytics collection while doing every day development.
//       await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false); 
//     } else {
//       // Release mode - Handle different types
//       await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//     }
//   }

//   static Future<void>? sendFatalCrash(exception, stackTrace) {
//     if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
//       FirebaseCrashlytics.instance.recordError(exception, stackTrace, fatal: true, reason: "A Fatal Error");
//     }

//     return null;
//   }

//    static Future<void>? sendNonFatalCrash(exception, stackTrace) {
//     if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
//       FirebaseCrashlytics.instance.recordError(exception, stackTrace, reason: "A Non-fatal Error");
//     }

//     return null;
//   }
// }