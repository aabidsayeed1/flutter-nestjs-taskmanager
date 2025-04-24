import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/constants/app_urls.dart';
import 'package:task_manager/core/generic/base_data_source.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';

class UpdateTaskDataSource implements BaseDataSource {
  final CustomHttpClient client;
  UpdateTaskDataSource({required this.client});

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic requestModel) async {
    requestModel as TaskModel;
    final taskId = requestModel.id;
    final updateModel = requestModel.copyWith(id: '').toJson();
    final Response response = await client.patch(Uri.parse(AppUrls.TASKS(id: taskId)), updateModel);
    int nResponseCode = response.statusCode;
    if (nResponseCode == 201 || nResponseCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null) {
        if (jsonData != null && jsonData['status'] == true) {
          if (jsonData["entity"] != null) {
            return const Right(true);
          }
        }
      }
    }
    return Left(response);
  }
}
