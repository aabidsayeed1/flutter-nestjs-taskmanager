class LoginResponseModel {
  final String token;
  final String name;
  final String id;
  final String email;
  const LoginResponseModel({
    required this.token,
    required this.id,
    required this.email,
    required this.name,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? "",
      name: json['name'] ?? "",
      id: json['user_id'] ?? "",
      email: json['email'] ?? "",
    );
  }
}
