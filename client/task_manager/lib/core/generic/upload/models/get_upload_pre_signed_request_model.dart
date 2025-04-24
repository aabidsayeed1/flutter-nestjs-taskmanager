import 'dart:convert';

class GetUploadPreSignedRequestModel {
  final String fileKey;
  const GetUploadPreSignedRequestModel({required this.fileKey});

  String toJson() => jsonEncode({
        "fileKey": fileKey,
      });
}
