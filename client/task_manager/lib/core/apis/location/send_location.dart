import 'dart:convert';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';

class SendLocationDataSource {
  sendLocation({
    required String strUserId,
    required double dLatitude,
    required double dLongitude,
    required String url,
  }) async {
    CustomHttpClient client = CustomHttpClient();

    var bodyData = {'latitude': dLatitude, 'longitude': dLongitude};

    Utils.printLogs("===========================");
    Utils.printLogs("Sending Location to server");
    Utils.printLogs(dLatitude);
    Utils.printLogs(dLongitude);

    try {
      final response = await client.post(Uri.parse(url), jsonEncode(bodyData));
      if (response.statusCode == 200) {
        Utils.printLogs("Success in sending location to server");
        LoggingManager.logEvent(jsonEncode(bodyData), LoggingType.info, "location to server");
      } else {
        Utils.printLogs("Error in sending location");
        LoggingManager.logError(
          response.statusCode,
          "",
          LoggingType.error,
          "Error in sending location",
        );
      }
    } catch (exception, stackTrace) {
      Utils.printLogs("Error in sending location $exception");
      LoggingManager.logError(
        exception,
        stackTrace,
        LoggingType.error,
        "Error in sending location",
      );
    }
    Utils.printLogs("===========================");
  }
}
