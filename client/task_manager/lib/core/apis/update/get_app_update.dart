import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/apis/update/app_model.dart';
import 'package:task_manager/core/apis/update/app_update_model.dart';
import 'package:task_manager/core/generic/base_data_source.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';

class GetAppUpdateDataSource extends BaseDataSource {
  CustomHttpClient client = CustomHttpClient();
  Future<dynamic> getAppUpdate(AppModel appModel) async {
    bool bUpdate = false;
    String strURL = AppUrls.GET_APP_UPDATE;

    final bodyData = {
      "versionName": appModel.strVersionName,
      "buildNumber": appModel.strBuildNumber,
      "os": appModel.strOS,
      "osVersion": appModel.strOSVersion,
    };

    Utils.printLogs(bodyData);

    final response = await client.post(Uri.parse(strURL), jsonEncode(bodyData));

    int nResponseCode = response.statusCode;
    if (nResponseCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        if (jsonData["entity"] != null) {
          if (jsonData["entity"]["forceUpdate"] != null) {
            bUpdate = jsonData["entity"]["forceUpdate"];
          }
        }
      }
    }

    return bUpdate;
  }

  Future<AppUpdateModel?> getAppFeatureForceUpdate(AppModel appModel) async {
    AppUpdateModel? appUpdate;
    String strURL = AppUrls.GET_APP_UPDATE;
    final bodyData = {
      "versionName": appModel.strVersionName,
      "buildNumber": appModel.strBuildNumber,
      "os": appModel.strOS,
      "osVersion": appModel.strOSVersion,
    };

    Utils.printLogs(bodyData);

    final response = await client.post(Uri.parse(strURL), jsonEncode(bodyData));

    int nResponseCode = response.statusCode;
    if (nResponseCode == 200 || nResponseCode == 201) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        appUpdate = AppUpdateModel.fromJson(jsonData['entity']);
      }
    }
    return appUpdate;
  }

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic data) async {
    final bodyData = {
      "versionName": data.strVersionName,
      "os": data.strOS,
      "buildNumber": data.strBuildNumber,
      "osVersion": data.strOSVersion,
    };
    final Response response = await client.post(
      Uri.parse(AppUrls.GET_APP_UPDATE),
      jsonEncode(bodyData),
    );
    int nResponseCode = response.statusCode;

    if (nResponseCode == 200 || nResponseCode == 201) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        if (jsonData["entity"] != null) {
          final responseModel = AppUpdateModel.fromJson(json.decode(response.body)['entity']);
          LoggingManager.logEvent(
            data.toJson(),
            LoggingType.info,
            "feature force update validated",
          );
          return Right(responseModel);
        }
      }
    }

    return Left(response);
  }
}

Map<String, dynamic> appFeatureForceUpdateMap = {
  "notifyUpdate": true,
  "forceUpdate": false,
  "latestVersion": "1.3.9",
  "features": ["events", "AccountSharing", "favourites"],
};
