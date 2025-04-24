import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/update/app_update_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/managers/general/overlay_manager.dart';
import 'dart:convert';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'helper_file.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class Utils {
  static String _strAppVersion = '';
  static AppUpdateModel? appFeatureForceUpdate;

  static void printJson(String input) {
    if (kDebugMode) {
      var decoded = const JsonDecoder().convert(input);
      var prettyJson = const JsonEncoder.withIndent(' ').convert(decoded);
      Utils.printLogs(prettyJson);
    }
  }

  static isPlatformAndroid() {
    return Platform.isAndroid;
  }

  static isPlatformiOS() {
    return Platform.isIOS;
  }

  static EdgeInsets getStatusBarSize(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Brightness getCurrentAppTheme(BuildContext context) {
    return View.of(context).platformDispatcher.platformBrightness;
  }

  static getAppTextTheme(context) {
    return Theme.of(context).textTheme;
  }

  static void dismissKeypad(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static String getAppName() {
    return F.title;
  }

  // Print only in debug builds
  static printLogs(dynamic strData) {
    if (kDebugMode) {
      print(strData);
    }
  }

  //number text field
  static bool phoneNumberValidate(String phoneNumber, int length) {
    return phoneNumber.length == length;
  }

  static String getLocalizedString(
    BuildContext context,
    String strKey, {
    Map<String, String>? args,
  }) {
    final AppLocalizations? localizations = AppLocalizations.of(context);
    if (localizations == null) {
      debugPrint("AppLocalizations is null for key: $strKey");
      return strKey;
    }
    return localizations.translate(strKey, args: args);
  }

  static setAppVersion(String strAppVersion) {
    _strAppVersion = strAppVersion;
  }

  static getAppVersion() {
    return _strAppVersion;
  }

  static set featureForceUpdate(AppUpdateModel? appFeatureFroce) {
    appFeatureForceUpdate = appFeatureFroce;
  }

  static AppUpdateModel? get featureForceUpdate {
    return appFeatureForceUpdate;
  }

  static Future<String> getBase64({required File? file}) async {
    String strBase64 = "";
    String strExtension = file!.path.split(".").last;
    var strRandomExtension = Random().nextInt(100000 - 10).toString();
    String strFileName = "${HelperUser.getUserId()}$strRandomExtension.$strExtension";

    Uint8List fileAsBytes;
    Utils.printLogs("printing file path ${file.path}");
    final outputPath = await HelperFile.getTempFilePath(
      strPrefixFileName: AppStrings.PREFIX_FOR_UPLOAD,
      strFile: strFileName,
      extension: strFileName,
    );
    XFile? result = await HelperFile.compressFile("image", file.path, outputPath);
    if (result != null) {
      fileAsBytes = await result.readAsBytes();
      strBase64 = base64Encode(fileAsBytes);
      Utils.printLogs("The base64 for image is = $strBase64");
    }
    return strBase64;
  }

  static setBaseUrl(String baseUrl) {
    SharedPreferencesManager.setString(AppUrls.BASE_URL, baseUrl);
  }

  static String getBaseUrl() {
    return SharedPreferencesManager.getString(AppUrls.BASE_URL);
  }

  static getBatteryLevel() async {
    // var batteryInfo = (await BatteryInfoPlugin().androidBatteryInfo);
    // return batteryInfo != null ? (batteryInfo.batteryLevel) : null;
  }

  static goToAppSettings() {
    if (Utils.isPlatformiOS()) {
      AppSettings.openAppSettings(); // As ios does not allow to go to wifi directly
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.wifi);
    }
  }

  // Today we support only India - so Rs
  static String getCurrency() {
    return "₹";
  }

  static String formatAmount(num numAmount) {
    final formatter = NumberFormat('#,##0.##'); // Format for commas and 2 decimal places
    return formatter.format(numAmount);
  }

  static bool isValidUPI(String strUPI) {
    // Define the UPI validation regex
    RegExp upiRegex = RegExp(r"^[\w.\-_]{2,256}@[a-zA-Z]{2,64}$");

    // Check if the UPI ID matches the regex
    final bResult = upiRegex.hasMatch(strUPI);
    return bResult;
  }

  static getCountryCode() {
    return '+91 ';
  }

  static getCurrencySymbol() {
    return '₹';
  }

  static getEnergyWhUnit() {
    return 'Wh';
  }

  static String formatWh(String strWh) {
    double value = double.parse(strWh);
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

  static String maskPhoneNumber(String strPhoneNumber, {int nMaskStart = 0, int nMaskEnd = 6}) {
    if (strPhoneNumber.length < 10) {
      throw ArgumentError('Phone number must have at least 10 digits');
    }

    // Mask the middle 6 digits
    return strPhoneNumber.replaceRange(nMaskStart, nMaskEnd, '******');
  }

  static shareData(String strShare, String strImageURL) {
    String strShareText = strShare;

    Share.share(strShareText);
  }

  static void copyToClipboard(String strLink) async {
    Clipboard.setData(ClipboardData(text: strLink)).then((_) {
      HelperUI.showToast(msg: "STRING_COPIED_TO_CLIPBOARD".tr(), type: ToastType.information);
    });
  }

  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    // final BaseDeviceInfo device = await deviceInfoPlugin.deviceInfo;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

      Utils.printLogs("device = ${androidInfo.version.release}");

      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      Utils.printLogs("device = ${iosInfo.systemVersion}");
      return iosInfo.systemVersion;
    }

    return "Unknown OS";
  }
}
