class PresignedFieldsModel {
  final String key;
  final String bucket;
  final String xAmzAlgorithm;
  final String xAmzCredential;
  final String xAmzDate;
  final String xAmzSignature;
  final String policy;

  PresignedFieldsModel(
      {required this.bucket,
      required this.key,
      required this.policy,
      required this.xAmzAlgorithm,
      required this.xAmzCredential,
      required this.xAmzDate,
      required this.xAmzSignature});

  factory PresignedFieldsModel.fromJson(Map<String, dynamic> json) {
    return PresignedFieldsModel(
      key: json["key"] ?? "",
      bucket: json["bucket"] ?? "",
      xAmzAlgorithm: json["X-Amz-Algorithm"] ?? "",
      xAmzCredential: json["X-Amz-Credential"] ?? "",
      xAmzDate: json["X-Amz-Date"] ?? "",
      xAmzSignature: json["X-Amz-Signature"] ?? "",
      policy: json["Policy"] ?? "",
    );
  }
}
