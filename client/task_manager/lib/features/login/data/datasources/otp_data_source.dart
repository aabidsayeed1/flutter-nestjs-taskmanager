import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/generic/base_data_source.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';
import 'package:task_manager/features/login/data/models/verify_otp_response_model.dart';
import 'package:http/http.dart';

class OTPDataSource implements BaseDataSource {
  final CustomHttpClient client;

  OTPDataSource({required this.client});

  @override
  Future<Either<Response, dynamic>> dataSourceMethod(dynamic requestModel) async {
    final Response response = await client.post(
      Uri.parse(AppUrls.VERIFY_OTP),
      requestModel.toJson(),
    );
    Utils.printLogs("OTP Response: ${response.body}");
    int nResponseCode = response.statusCode;
    if (nResponseCode == 200 || nResponseCode == 201) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['status'] == true) {
        if (jsonData["entity"] != null) {
          final responseModel = VerifyOTPResponseModel.fromJson(jsonData["entity"]);
          LoggingManager.logEvent(requestModel.toJson(), LoggingType.info, "verify otp");
          return Right(responseModel);
        }
      }
    }

    return Left(response);
  }
}
