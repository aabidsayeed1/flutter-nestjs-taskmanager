import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/helpers/helper_file.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ValidityCheck<T> {
  Future<Either<String, T>> checkAndProceedToDataSource(dynamic T, {dynamic data = ""}) async {
    bool bInternet = await InternetConnectionChecker.instance.hasConnection;

    if (bInternet) {
      Utils.printLogs("Network available");

      String error = "";
      try {
        dynamic leftResult;
        var resultResponse = await T.dataSourceMethod(data);

        await resultResponse.fold(
          (failure) {
            Response result = failure;
            leftResult = const Left(AppStrings.ERROR_SERVER_FAILURE);
            error = AppStrings.ERROR_SERVER_FAILURE;

            try {
              switch (result.statusCode) {
                case 200:
                case 201:
                case 400:
                  {
                    var jsonData = jsonDecode(result.body);
                    if (jsonData != null && jsonData['status'] == false) {
                      if (jsonData["message"] != null &&
                          jsonData["message"].toString().isNotEmpty) {
                        String strError = jsonData["message"];
                        Utils.printLogs(strError);
                        leftResult = Left(strError);
                        error = strError;
                      } else {
                        leftResult = const Left(AppStrings.ERROR_SERVER_FAILURE);
                        error = AppStrings.ERROR_SERVER_FAILURE;
                      }
                    }
                  }
                  break;

                case 404:
                  {
                    var jsonData = jsonDecode(result.body);
                    if (jsonData != null && jsonData['status'] == false) {
                      if (jsonData["message"] != null &&
                          jsonData["message"].toString().isNotEmpty) {
                        String strError = jsonData["message"];
                        Utils.printLogs(strError);
                        leftResult = Left(strError);
                        error = strError;
                      } else {
                        leftResult = Left("ERROR_NOT_FOUND".tr());
                        error = "ERROR_NOT_FOUND".tr();
                      }
                    }
                  }
                  break;

                case 409:
                  {
                    var jsonData = jsonDecode(result.body);
                    if (jsonData != null && jsonData['status'] == false) {
                      if (jsonData["message"] != null &&
                          jsonData["message"].toString().isNotEmpty) {
                        String strError = jsonData["message"];
                        Utils.printLogs(strError);
                        leftResult = Left(strError);
                        error = strError;
                      } else {
                        leftResult = Left("ERROR_SOME_THING_WENT_WRONG".tr());
                        error = "ERROR_SOME_THING_WENT_WRONG".tr();
                      }
                    }
                  }
                  break;

                case 500:
                  {
                    leftResult = Left("ERROR_INTERNAL_SERVER_FAILURE".tr());
                    error = "ERROR_INTERNAL_SERVER_FAILURE".tr();

                    try {
                      var jsonData = jsonDecode(result.body);
                      if (jsonData != null && jsonData["message"] != null) {
                        String errorMessage = jsonData["message"];
                        leftResult = Left(errorMessage);
                        error = errorMessage;
                      }
                    } catch (e) {
                      Utils.printLogs("Error while decoding status code 500");
                    }
                  }
                  break;

                case 501:
                  leftResult = Left("ERROR_NOT_IMPLEMENTED".tr());
                  error = "ERROR_NOT_IMPLEMENTED".tr();
                  break;

                case 000:
                  leftResult = Left("ERROR_GENERAL_FAILURE".tr());
                  error = "ERROR_GENERAL_FAILURE".tr();
                  break;

                case 403:
                  leftResult = Left("ERROR_NO_ACCESS".tr());
                  error = "ERROR_NO_ACCESS".tr();
                  break;

                default:
                  leftResult = Left("ERROR_NOT_IMPLEMENTED".tr());
                  error = "ERROR_NOT_IMPLEMENTED".tr();
                  break;
              }
            } catch (e) {
              Utils.printLogs("Exception while processing response: ${e.toString()}");
              LoggingManager.logError(
                "Exception while processing response: ${e.toString()}",
                "",
                LoggingType.error,
                "Exception while processing response",
              );

              leftResult = Left("ERROR_SOME_THING_WENT_WRONG".tr());
              error = "ERROR_SOME_THING_WENT_WRONG".tr();
            }
          },
          (loaded) {
            return Right(resultResponse);
          },
        );

        if (resultResponse.isLeft()) {
          LoggingManager.logError("", "", LoggingType.error, error);
          return leftResult;
        }

        return Right(resultResponse);
      } catch (e) {
        Utils.printLogs("Exception while processing response: ${e.toString()}");
        if (e is SocketException) {
          return Left("ERROR_SERVER_FAILURE".tr());
        } else if (e is TimeoutException) {
          return Left("ERROR_TIME_OUT".tr());
        } else if (e is HttpException) {
          return Left("ERROR_HTTP_EXCEPTION".tr());
        } else if (e.toString().contains('Unauthorized')) {
          return Left("ERROR_UNAUTHORIZED".tr());
        }
        LoggingManager.logError(
          "Exception while processing response: ${e.toString()}",
          "",
          LoggingType.error,
          "Exception while processing response",
        );
        return Left("ERROR_SOME_THING_WENT_WRONG".tr());
      }
    } else {
      Utils.printLogs("Network NOT available");
      LoggingManager.logError("", "", LoggingType.error, "ERROR_INTERNET_FAILURE".tr());
      return Left("ERROR_INTERNET_FAILURE".tr());
    }
  }
}
