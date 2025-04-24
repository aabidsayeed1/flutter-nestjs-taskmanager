import 'dart:convert';

import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';

class SendFcmTokenDataSource extends CustomHttpClient {
  Future<dynamic> sendFcmtoken({required String strFcmToken}) async {
    String strURL = AppUrls.URL_SEND_FCM_TOKEN;

    var bodyData = {'deviceToken': strFcmToken};
    final response = await put(Uri.parse(strURL), jsonEncode(bodyData));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['entity']['deviceToken'];
    } else {
      Utils.printLogs('failed to send fcm token');
      return null;
    }
  }
}
