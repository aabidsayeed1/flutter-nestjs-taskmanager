class VerifyOTPResponseModel {
  final String accessToken;
  final String refreshToken;
  final String mobile;
  final String id;
  const VerifyOTPResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
    required this.mobile,
  });

  factory VerifyOTPResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOTPResponseModel(
      accessToken: json['access_token'] ?? "",
      refreshToken: json['refresh_token'] ?? "",
      mobile: json['mobile'] ?? "",
      id: json['id'] ?? "",
    );
  }
}
