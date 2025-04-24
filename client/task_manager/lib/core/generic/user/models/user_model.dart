// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/generic/user/models/user_tata_model.dart';
import 'package:task_manager/core/generic/user/models/user_tuya_model.dart';

import 'user_role_type.dart';

class UserModel {
  final String strId;
  final String strName;
  final String strUserSetupId;
  final String strSetupId;
  final String strPhoneNumber;
  final String strProfilePicture;
  final String strProfilePictureKey;
  final String strEmail;
  final UserRoleType userRoleType;
  final int nUserDeviceCount;
  final UserTuyaModel? userTuyaModel;
  final UserTataModel? userTataModel;
  final bool bIsPowupEnabled;

  const UserModel({
    required this.strId,
    required this.strName,
    required this.strUserSetupId,
    required this.strSetupId,
    required this.strPhoneNumber,
    required this.strProfilePicture,
    required this.strProfilePictureKey,
    required this.strEmail,
    required this.userRoleType,
    required this.nUserDeviceCount,
    required this.userTuyaModel,
    required this.userTataModel,
    required this.bIsPowupEnabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      strId: json['id'] ?? '',
      strName: json['name'] ?? '',
      strUserSetupId: json['userSetupId'] ?? '',
      strSetupId: json['setupId'] ?? '',
      strPhoneNumber: json['phoneNumber'] ?? '',
      strProfilePicture: '',
      strProfilePictureKey: json['profilePicture'] ?? '',
      strEmail: json['email'] ?? '',
      userRoleType: UserRoleType.fromString(json['role'] ?? ''),
      nUserDeviceCount: json['userDeviceCount'] ?? 0,
      userTuyaModel:
          (json['userVendorIds'] != null && json['userVendorIds']['TUYA'] != null)
              ? UserTuyaModel.fromJson(json)
              : null,
      userTataModel:
          (json['userVendorIds'] != null && json['userVendorIds']['TATA'] != null)
              ? UserTataModel.fromJson(json)
              : null,
      bIsPowupEnabled: json['isPowUpEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': strId,
      'name': strName,
      'userSetupId': strUserSetupId,
      'setupId': strSetupId,
      'phoneNumber': strPhoneNumber,
      'profilePicture': strProfilePicture,
      'profilePictureKey': strProfilePictureKey,
      'email': strEmail,
      'userDeviceCount': nUserDeviceCount,
    };
  }

  UserModel copyWith({
    String? strId,
    String? strName,
    String? strUserSetupId,
    String? strSetupId,
    String? strPhoneNumber,
    String? strProfilePicture,
    String? strProfilePictureKey,
    String? strEmail,
    UserRoleType? userRoleType,
    int? nUserDeviceCount,
    UserTuyaModel? userTuyaModel,
    UserTataModel? userTataModel,
    bool? bIsPowupEnabled,
  }) {
    return UserModel(
      strId: strId ?? this.strId,
      strName: strName ?? this.strName,
      strUserSetupId: strUserSetupId ?? this.strUserSetupId,
      strSetupId: strSetupId ?? this.strSetupId,
      strPhoneNumber: strPhoneNumber ?? this.strPhoneNumber,
      strProfilePicture: strProfilePicture ?? this.strProfilePicture,
      strProfilePictureKey: strProfilePictureKey ?? this.strProfilePictureKey,
      strEmail: strEmail ?? this.strEmail,
      userRoleType: userRoleType ?? this.userRoleType,
      nUserDeviceCount: nUserDeviceCount ?? this.nUserDeviceCount,
      userTuyaModel: userTuyaModel ?? this.userTuyaModel,
      userTataModel: userTataModel ?? this.userTataModel,
      bIsPowupEnabled: bIsPowupEnabled ?? this.bIsPowupEnabled,
    );
  }
}
