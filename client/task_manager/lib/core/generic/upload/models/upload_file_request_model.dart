import 'dart:convert';
import 'package:task_manager/core/managers/general/custom_media_picker_manager.dart';
import 'get_upload_pre_signed_response_model.dart';

class UploadFileRequesteModel {
  final String strFolderName;
  final String strFileName;
  final GetUploadPreSignedResponseModel getuploadFileRequestModel;
  final String filePath;
  final MediaPickerResult? file;
  final String? base64;

  UploadFileRequesteModel({
    required this.strFolderName,
    required this.strFileName,
    required this.getuploadFileRequestModel,
    required this.filePath,
    this.base64,
    required this.file,
  });

  String toJson() => jsonEncode({"fileKey": strFileName});
}
