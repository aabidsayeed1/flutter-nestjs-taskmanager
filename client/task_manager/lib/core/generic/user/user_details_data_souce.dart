import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/generic/base_data_source.dart';
import 'package:task_manager/core/generic/user/models/user_model.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';
import 'package:http/http.dart';

class UserDetailsDataSource extends BaseDataSource {
  final CustomHttpClient client;
  UserDetailsDataSource({required this.client});

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic data) async {
    final Response response = await client.get(Uri.parse(AppUrls.USER_DETAILS));
    int nResponseCode = response.statusCode;

    if (nResponseCode == 201 || nResponseCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData != null && jsonData['status'] == true) {
        if (jsonData["entity"] != null) {
          final response = UserModel.fromJson(jsonData['entity']);
          LoggingManager.logEvent("", LoggingType.info, "Get User Details");
          return Right(response);
        }
      }
    }
    return Left(response);
  }
}
