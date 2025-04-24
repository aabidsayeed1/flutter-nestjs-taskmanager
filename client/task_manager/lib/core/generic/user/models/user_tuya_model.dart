class UserTuyaModel {
  final String strUserVendorId;
  final String strUserId; // Tuya user id

  UserTuyaModel({required this.strUserVendorId, required this.strUserId});

  factory UserTuyaModel.fromJson(Map<String, dynamic> json) {
    return UserTuyaModel(
      strUserVendorId: json['userVendorIds']['TUYA']['userVendorId'] ?? "",
      strUserId: json['userVendorIds']['TUYA']['userIdFromVendor'] ?? "",
    );
  }
}
