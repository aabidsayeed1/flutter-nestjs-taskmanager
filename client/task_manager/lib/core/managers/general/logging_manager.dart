import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';

enum LoggingType { info, error }

class LoggingManager {
  static CustomHttpClient client = CustomHttpClient();
  static Future<dynamic> logEvent(
    value,
    LoggingType strType,
    String strMessage, {
    bool storeOffline = false,
  }) async {
    String os = Platform.operatingSystem;
    String osVersion = Platform.operatingSystemVersion;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    final device = await deviceInfoPlugin.deviceInfo;
    final String deviceInfo = "${device.data["brand"]}- ${device.data["model"]}";
    var batteryLevel = await Utils.getBatteryLevel();
    Utils.printLogs("battery_level is $batteryLevel");

    final bodyData = {
      "type": strType.toString().split('.').last,
      "message": strMessage,
      "data": {
        "device": deviceInfo,
        "os": "$os - $osVersion",
        "app_version": "${Utils.getAppVersion()}",
        "battery_level": "$batteryLevel",
        "eventData": "$value",
        "userId": HelperUser.getUserId(),
      },
    };

    String strURL = AppUrls.SEND_LOGS;
    // try {
    //   final response = await client.post(Uri.parse(strURL), jsonEncode(bodyData));
    //   //    print("********************************");
    //   // print("$bodyData");
    //   //  print("********************************");
    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     Utils.printLogs("type:==> $strType $value ${response.body}");
    //   } else {
    //     Utils.printLogs("logEvent : Failed to send logs");
    //   }
    // } catch (exception) {
    //   Utils.printLogs("logEvent : Failed to send logs in catch $exception");
    //   // if (!(await InternetConnectionChecker().hasConnection) &&
    //   //     storeOffline &&
    //   //     await ChecklistHelper.isOfflineChecklistBoxOpen()) {
    //   //   handleLogsOffline(
    //   //       body: jsonEncode(bodyData),
    //   //       url: strURL,
    //   //       requestType: HttpRequestTypes.post);
    //   // }
    // }
  }

  static Future<dynamic> logError(
    error,
    stackTrace,
    LoggingType strType,
    String strMessage, {
    bool storeOffline = false,
  }) async {
    String os = Platform.operatingSystem;
    String osVersion = Platform.operatingSystemVersion;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final device = await deviceInfoPlugin.deviceInfo;
    final String deviceInfo = "${device.data["brand"]}- ${device.data["model"]}";

    var batteryLevel = await Utils.getBatteryLevel();
    Utils.printLogs("battery_level is $batteryLevel");

    final bodyData = {
      "type": strType.toString().split('.').last,
      "message": strMessage,
      "data": {
        "eventData": {
          "device": deviceInfo,
          "os": "$os - $osVersion",
          "app_version": "${Utils.getAppVersion()}",
          "battery_level": "$batteryLevel",
          "error": "$error",
          "stackTrace": "$stackTrace",
          "userId": HelperUser.getUserId(),
        },
      },
    };

    String strURL = AppUrls.SEND_LOGS;
    // try {
    //   final response = await client.post(Uri.parse(strURL), jsonEncode(bodyData));
    //   //  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    //   // print("$bodyData");
    //   //   print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    //   if (response.statusCode == 200) {
    //     Utils.printLogs("type:==> $strType ${response.body}");
    //   } else {
    //     Utils.printLogs("logError : Failed to send logs");
    //   }
    // } catch (exception) {
    //   Utils.printLogs("logError : Failed to send logs in catch $exception");
    //   // if (!(await InternetConnectionChecker().hasConnection) &&
    //   //     storeOffline &&
    //   //     await ChecklistHelper.isOfflineChecklistBoxOpen()) {
    //   //   handleLogsOffline(
    //   //       body: jsonEncode(bodyData),
    //   //       url: strURL,
    //   //       requestType: HttpRequestTypes.post);
    //   // }
    // }
  }

  // static handleLogsOffline(
  //     {required String body,
  //     required String url,
  //     required HttpRequestTypes requestType}) async {
  //   String timestamp = DateTimeManager.getTimeStamp();
  //   CheckListOfflineModel checkListOfflineModel = CheckListOfflineModel(
  //       url: [url], data: body, serviceId: "", httpRequestTypes: [requestType]);
  //   await ChecklistHelper.addOfflineCheckList(timestamp, checkListOfflineModel);
  // }
}
