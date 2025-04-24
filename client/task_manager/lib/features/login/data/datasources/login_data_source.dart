import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/generic/base_data_source.dart';
import 'package:http/http.dart';

class LoginDataSource implements BaseDataSource {
  final CustomHttpClient client;
  LoginDataSource({required this.client});

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic requestModel) async {
    final Response response = await client.post(Uri.parse(AppUrls.LOGIN), requestModel.toJson());
    int nResponseCode = response.statusCode;
    if (nResponseCode == 201) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        if (jsonData["entity"] != null) {
          return Right(true);
        }
      }
    }

    return Left(response);
  }
}
