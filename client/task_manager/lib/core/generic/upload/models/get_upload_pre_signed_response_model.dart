import 'pre_signed_fields_model.dart';

class GetUploadPreSignedResponseModel {
  final String url;
  final PresignedFieldsModel fields;
  GetUploadPreSignedResponseModel({required this.url, required this.fields});

  factory GetUploadPreSignedResponseModel.fromJson(Map<String, dynamic> json) {
    return GetUploadPreSignedResponseModel(
        url: json['url'] ?? "",
        fields: PresignedFieldsModel.fromJson(json["fields"]));
  }
}
