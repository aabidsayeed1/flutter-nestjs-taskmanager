class UserTataModel {
  final String strUserVendorId;
  final String strUserId; // Tata user id
  final String strUserToken;
  final String strCANumber;
  final String strTataPhoneNumber;

  UserTataModel({
    required this.strUserVendorId,
    required this.strUserId,
    required this.strUserToken,
    required this.strCANumber,
    required this.strTataPhoneNumber,
  });

  factory UserTataModel.fromJson(Map<String, dynamic> json) {
    return UserTataModel(
      strUserVendorId: json['userVendorIds']['TATA']['userVendorId'] ?? "",
      strUserId: json['userVendorIds']['TATA']['userIdFromVendor'] ?? "",
      strUserToken: json['userVendorIds']['TATA']['tataUserToken'] ?? "",
      strCANumber: json['userVendorIds']['TATA']['caId'] ?? "",
      strTataPhoneNumber: json['userVendorIds']['TATA']['tataPhoneNumber'] ?? "",
    );
  }
}
