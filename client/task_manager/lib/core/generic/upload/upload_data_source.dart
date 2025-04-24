import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:task_manager/core/constants/app_strings.dart';
import 'package:task_manager/core/generic/upload/models/upload_file_reponse_model.dart';
import 'package:task_manager/core/generic/upload/models/upload_file_request_model.dart';
import 'package:task_manager/core/helpers/helper_file.dart';
import 'package:task_manager/core/helpers/utils.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';
import 'package:task_manager/core/utils/multipart_client.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UploadDataSource {
  static Future<Either<http.Response, UploadFileResponseModel>> uploadFile(
    UploadFileRequesteModel requestModel,
  ) async {
    // ignore: prefer_typing_uninitialized_variables
    var fileAsBytes;
    if (requestModel.base64 != null && requestModel.base64!.isNotEmpty) {
      fileAsBytes = base64.decode(requestModel.base64 ?? "");
    }
    var fields = requestModel.getuploadFileRequestModel.fields;
    var jsonOfFields = {
      "key": fields.key,
      "bucket": fields.bucket,
      "X-Amz-Algorithm": fields.xAmzAlgorithm,
      "X-Amz-Credential": fields.xAmzCredential,
      "X-Amz-Date": fields.xAmzDate,
      "Policy": fields.policy,
      "X-Amz-Signature": fields.xAmzSignature,
    };

    var request = MultipartRequest(
      AppStrings.STRING_HTTP_METHOD_POST,
      Uri.parse(requestModel.getuploadFileRequestModel.url),
      onProgress: ((bytes, totalBytes) => {Utils.printLogs("Uploading")}),
    );

    for (final data in jsonOfFields.keys) {
      final value = jsonOfFields[data];
      Utils.printLogs("request data $value");
      request.fields[data] = value!;
    }

    String strExtension = requestModel.strFileName.split(".").last;

    String strContentType = lookupMimeType('*.$strExtension')!;
    int slashIndex = strContentType.indexOf('/');
    String strMediaType = strContentType.substring(0, slashIndex);
    String strFileName = requestModel.strFileName;
    String strFolderName = requestModel.strFolderName;
    String strActualFilename = "";
    if (fileAsBytes == null) {
      strActualFilename = requestModel.file!.selectedFile!.path;
    }

    String strFullPath = strFolderName + strFileName;

    if (fileAsBytes != null || requestModel.file!.selectedFile != null) {
      if (fileAsBytes == null) {
        try {
          if (strMediaType == "video") {
          } else {
            final outputPath = await HelperFile.getTempFilePath(
              strPrefixFileName: AppStrings.PREFIX_FOR_UPLOAD,
              strFile: strFullPath,
              extension: strExtension,
            );
            XFile? result = await HelperFile.compressFile(
              strMediaType,
              strActualFilename,
              outputPath,
            );
            // final result = await FlutterImageCompress.compressAndGetFile(
            //   strActualFilename,
            //   outputPath,
            //   minWidth: 1080,
            //   minHeight: 720,
            //   quality: 30,
            // );
            if (result != null) {
              fileAsBytes = await result.readAsBytes();

              ///deleting compressed file after uploading
              HelperFile.deleteFile(result.path);
            }
          }
        } catch (e) {
          ///there was exception compressing media, so upload original file
          fileAsBytes = await requestModel.file!.selectedFile!.readAsBytes();
        }
      }

      if (fileAsBytes != null) {
        Utils.printLogs("file in bytes: $fileAsBytes");
        request.fields[AppStrings.CONTENT_TYPE] = strContentType;
        //request.fields[AppStrings.KEY_ACL] = AppStrings.ACL_PUBLIC_READ;

        Utils.printLogs("requestModel.mediaType = $strMediaType");
        Utils.printLogs("requestModel.strExtension = $strExtension");
        request.files.add(
          http.MultipartFile.fromBytes(
            AppStrings.KEY_FILE,
            fileAsBytes,
            filename: strFileName,
            contentType: MediaType(strMediaType, strExtension),
          ),
        );
        var response = await request.send();

        http.Response res = await http.Response.fromStream(response);
        Utils.printLogs("createUploadResponse: ${res.body}");
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204) {
          String mediaUrl = "${requestModel.strFolderName}${requestModel.strFileName}";

          //"${requestModel.getuploadFileRequestModel.url}/upload/$strFileName";
          Utils.printLogs("uploaded file url:  $mediaUrl");

          final responseModel = UploadFileResponseModel(
            mediaUrl: requestModel.strFileName,
            mediaType: strMediaType,
            fileUploaded: true,
            isNewMedia: true,
            mediaId: '',
            filepath: requestModel.filePath,
            uploadStatus: UploadStatus.none,
          );
          LoggingManager.logEvent(
            requestModel.toJson(),
            LoggingType.info,
            "update service checkpoints",
          );

          return Right(responseModel);
        }
        LoggingManager.logError(
          requestModel.toJson(),
          "",
          LoggingType.error,
          "failed to upload image",
        );
        return Left(http.Response("", response.statusCode));
      }
    }
    LoggingManager.logError(requestModel.toJson(), "", LoggingType.error, "failed to upload image");
    return Left(http.Response("", 000));
  }
}
