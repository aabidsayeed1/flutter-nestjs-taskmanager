import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/constants/app_urls.dart';
import 'package:task_manager/core/generic/base_data_source.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';

class CreateBatchTaskDataSource implements BaseDataSource {
  final CustomHttpClient client;
  CreateBatchTaskDataSource({required this.client});

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic requestModel) async {
    final Response response = await client.post(
      Uri.parse(AppUrls.TASKS_BATCH),
      jsonEncode(requestModel),
    );
    int nResponseCode = response.statusCode;
    if (nResponseCode == 200 || nResponseCode == 201) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        final List<dynamic> taskList = jsonData['entity'];
        final List<TaskModel> tasks = taskList.map((e) => TaskModel.fromMap(e)).toList();
        return Right(tasks);
      }
    }
    return Left(response);
  }
}
