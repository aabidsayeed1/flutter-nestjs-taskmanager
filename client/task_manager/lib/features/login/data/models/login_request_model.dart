import 'dart:convert';

class LoginRequestModel {
  const LoginRequestModel({required this.mobile});

  final String mobile;

  String toJson() => jsonEncode({"countryCode": "+91", "phoneNumber": mobile});
}
