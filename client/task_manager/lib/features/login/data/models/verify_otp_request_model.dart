import 'dart:convert';

class VerifyOTPRequestModel {
  const VerifyOTPRequestModel({
    required this.mobile,
    required this.otp,
  });

  final String mobile;
  final String otp;

  String toJson() => jsonEncode({
        "phoneNumber": mobile,
        "otp": otp,
      });
}
