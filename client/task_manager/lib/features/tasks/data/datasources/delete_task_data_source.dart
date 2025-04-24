import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/constants/app_urls.dart';
import 'package:task_manager/core/generic/base_data_source.dart';

class DeleteTaskDataSource implements BaseDataSource {
  final CustomHttpClient client;
  DeleteTaskDataSource({required this.client});

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic requestModel) async {
    final Response response =
        await client.delete(Uri.parse(AppUrls.TASKS(id:requestModel )), null);
    int nResponseCode = response.statusCode;
    if (nResponseCode == 201 || nResponseCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        return const Right(true);
      }
    }
    return Left(response);
  }
}
