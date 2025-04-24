import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/constants/app_urls.dart';
import 'package:task_manager/core/generic/base_data_source.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';

class CreateTaskDataSource implements BaseDataSource {
  final CustomHttpClient client;
  CreateTaskDataSource({required this.client});

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic requestModel) async {
    final Response response = await client.post(Uri.parse(AppUrls.TASKS()), requestModel);
    int nResponseCode = response.statusCode;
    if (nResponseCode == 201) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        if (jsonData["entity"] != null) {
          final response = TaskModel.fromMap(jsonData['entity']);
          return Right(response);
        }
      }
    }
    return Left(response);
  }
}
