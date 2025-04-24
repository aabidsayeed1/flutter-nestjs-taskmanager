// import 'dart:convert';
// import 'package:task_manager/core/managers/general/custom_media_picker_manager.dart';
// import 'package:task_manager/features/service/data/models/response/service_checklist/service_request_check_point_model.dart';

// class StartUploadFileRequesteModel {
//   final String strFolderName;
//   final String strFileName;
//   final MediaPickerResult? file;
//   final String filePath;
//   String? base64;
//   ServiceRequestCheckPointModel? serviceRequestCheckPointModel;

//   StartUploadFileRequesteModel(
//       {required this.strFolderName,
//       required this.strFileName,
//       required this.filePath,
//       required this.file,
//       this.base64,
//       this.serviceRequestCheckPointModel});

//   String toJson() => jsonEncode({
//         "fileKey": strFolderName + strFileName,
//         "base64": base64,
//         "serviceRequestCheckPointModel": serviceRequestCheckPointModel == null
//             ? null
//             : serviceRequestCheckPointModel!.toJson(),
//         "strFolderName": strFolderName,
//         "strFileName": strFileName,
//         "filePath": filePath,
//       });

//   factory StartUploadFileRequesteModel.fromJson(Map<String, dynamic> data) {
//     return StartUploadFileRequesteModel(
//         strFolderName: data["strFolderName"] ?? "",
//         strFileName: data["strFileName"] ?? "",
//         filePath: data["filePath"] ?? "",
//         file: data["file"],
//         base64: data["base64"] ?? "",
//         serviceRequestCheckPointModel: ServiceRequestCheckPointModel.fromJson(
//             json.decode(data["serviceRequestCheckPointModel"] ?? "{}")));
//   }
// }
