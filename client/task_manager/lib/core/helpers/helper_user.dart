import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/generic/user/models/user_model.dart';
import 'package:task_manager/core/generic/user/models/user_role_type.dart';
import 'package:task_manager/core/generic/user/models/user_tata_model.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';
import 'package:task_manager/route/global_navigator.dart';

class DeepLinkData {
  String? strType;
  String? strData;
}

class HelperUser {
  static UserModel? _userModel;
  static DeepLinkData? _deepLinkData;
  static String? _strTataToken;

  static bool isLoggedIN() {
    bool isLoggedIn = HelperUser.getAuthToken().isNotEmpty;
    // bool isLoggedIn = HelperUser.getUserId().isNotEmpty;
    return isLoggedIn;
  }

  //=================================
  static setUserId(String userId) {
    SharedPreferencesManager.setString(AppStrings.USER_ID, userId);
  }

  static String getUserId() {
    return SharedPreferencesManager.getString(AppStrings.USER_ID);
  }

  //=================================
  static setSetupId(String setupId) {
    SharedPreferencesManager.setString(AppStrings.USER_SETUP_ID, setupId);
  }

  static String getSetupId() {
    return SharedPreferencesManager.getString(AppStrings.USER_SETUP_ID);
  }

  //=================================
  static setUserSetupId(String setupId) {
    SharedPreferencesManager.setString(AppStrings.USER_USER_SETUP_ID, setupId);
  }

  static String getUserSetupId() {
    return SharedPreferencesManager.getString(AppStrings.USER_USER_SETUP_ID);
  }

  //=================================
  static setAuthToken(String token) {
    SharedPreferencesManager.setString(AppStrings.USER_TOKEN, token);
  }

  static String getAuthToken() {
    return SharedPreferencesManager.getString(AppStrings.USER_TOKEN);
  }

  //=================================
  static setRefreshToken(String token) {
    SharedPreferencesManager.setString(AppStrings.STRING_KEY_REFRESH_TOKEN, token);
  }

  static String getRefreshToken() {
    return SharedPreferencesManager.getString(AppStrings.STRING_KEY_REFRESH_TOKEN);
  }

  //=================================
  static setAccessToken(String token) {
    SharedPreferencesManager.setString(AppStrings.STRING_KEY_ACCESS_TOKEN, token);
  }

  static String getAccessToken() {
    return 'Bearer ${SharedPreferencesManager.getString(AppStrings.STRING_KEY_ACCESS_TOKEN)}';
  }

  //=================================
  static void setUser(UserModel userData) {
    _userModel = userData;

    // Store the name of the user into the shared preference
    if (_userModel != null) setUserName(_userModel!.strName);
  }

  static UserModel? getUser() {
    if (_userModel != null) {
      return _userModel!;
    } else {
      return null;
    }
  }

  //=================================
  // This gives without country code
  static String getPhoneNumber() {
    String strPhoneNumber = "";

    if (_userModel != null) {
      strPhoneNumber = _userModel!.strPhoneNumber.trim(); // Trim whitespace
      // Remove the country code +91 if it exists
      strPhoneNumber = strPhoneNumber.replaceFirst(RegExp(r'^\+91\s*'), '');
    }

    return strPhoneNumber;
  }

  //=================================
  static setUserName(String strName) {
    SharedPreferencesManager.setString(AppStrings.USER_NAME, strName);
  }

  static String getUserName() {
    return SharedPreferencesManager.getString(AppStrings.USER_NAME);
  }

  //=================================
  static String getProfileURL() {
    if (_userModel != null) {
      return _userModel!.strProfilePicture;
    }

    return "";
  }
  //=================================

  static setLocale(String strValue) {
    SharedPreferencesManager.setString(AppStrings.USER_LOCALE, strValue);
  }

  static String getLocale() {
    String strLocale = SharedPreferencesManager.getString(AppStrings.USER_LOCALE);
    if (strLocale.isEmpty) strLocale = "en";

    return strLocale;
  }

  static Future<void> logout({BuildContext? context}) async {
    HydratedBloc.storage.clear();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
    HelperUser.setAuthToken('');
    HelperUser.setAccessToken('');
    SharedPreferencesManager.setString(AppStrings.STRING_KEY_FCMTOKEN, '');
    await sl<NavigationService>().navigateToLogin();
  }

  //=================================
  static setIsSkipped(bool skip) {
    SharedPreferencesManager.setBool(HelperUser.getUserId(), skip);
  }

  static bool isSkipped() {
    return SharedPreferencesManager.getBool(HelperUser.getUserId());
  }

  //=================================
  static setDeepLinkData(DeepLinkData? deepLinkData) {
    _deepLinkData = deepLinkData;
  }

  static DeepLinkData? getDeepLinkData() {
    if (_deepLinkData != null) return _deepLinkData!;

    return null;
  }

  //=================================
  static String getUserRole() {
    String strValue = UserRoleType.unknown.toRuleString();
    if (_userModel != null) {
      strValue = _userModel!.userRoleType.toRuleString();
    }

    Utils.printLogs(strValue);

    return strValue;
  }

  static setUserRoleInStorage(String strUserRole) {
    SharedPreferencesManager.setString(AppStrings.USER_ROLE, strUserRole);
  }

  static UserRoleType getUserRoleFromStorage() {
    final role = SharedPreferencesManager.getString(AppStrings.USER_ROLE);
    return UserRoleType.fromString(role);
  }

  //=================================
  static getSupportPhoneNumber() {
    return '+91 9876543210';
  }

  static getSupportEmail() {
    return 'support@pow-dr.io';
  }

  //=================================
  static setMobileFromStorage(String strMobile) {
    SharedPreferencesManager.setString(AppStrings.USER_MOBILE, strMobile);
  }

  static String getMobileFromStorage() {
    return SharedPreferencesManager.getString(AppStrings.USER_MOBILE);
  }

  //=================================
  static setFaceIdToken(String strToken) {
    Utils.printLogs("setFaceIdToken setFaceIdToken = $strToken");
    String strKey = AppStrings.STRING_KEY_FACEID_TOKEN;
    if (strToken.isEmpty) {
      SharedPreferencesManager.removeKey(strKey);
    } else {
      SharedPreferencesManager.setString(strKey, strToken);
    }
  }

  static String getFaceIdToken() {
    String strKey = AppStrings.STRING_KEY_FACEID_TOKEN;
    Utils.printLogs("getFaceIdToken face id value= $strKey");

    return SharedPreferencesManager.getString(strKey);
  }

  //=================================
  static setFaceIdSelected(bool bValue) {
    SharedPreferencesManager.setBool(AppStrings.FACE_ID_LOGIN_SELECTED, bValue);
  }

  static bool getFaceIdSelected() {
    return SharedPreferencesManager.getBool(AppStrings.FACE_ID_LOGIN_SELECTED);
  }

  //=================================
  static UserTataModel? getTataDetails() {
    if (_userModel != null) {
      if (_userModel!.userTataModel != null) {
        return _userModel!.userTataModel;
      }
    }

    return null;
  }

  static setTataUserToken(String? strValue) {
    _strTataToken = strValue;
  }

  static getTataUserToken() {
    return _strTataToken;
  }
}
