import 'dart:io';

import 'package:task_manager/core/apis/update/app_model.dart';
import 'package:task_manager/core/apis/update/get_app_update.dart';
import 'package:task_manager/core/generic/validity_check.dart';
import 'package:task_manager/core/helpers/utils.dart';
import 'package:task_manager/core/managers/general/app_manager.dart';
import 'package:task_manager/core/managers/general/sharedpreferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../apis/update/app_update_model.dart';

class AppUpdateManager {
  static AppUpdateManager? _instance;
  AppUpdateManager._internal();
  static AppUpdateManager get instance {
    _instance ??= AppUpdateManager._internal();
    return _instance!;
  }

  static Future<void> initialize() async {
    await instance._checkForAppFeatureForceUpdate();
  }

  AppUpdateModel? _appUpdate;

  Future<AppUpdateModel?> _checkForAppFeatureForceUpdate() async {
    GetAppUpdateDataSource appUpdateDataSource = GetAppUpdateDataSource();
    ValidityCheck validityCheck = ValidityCheck();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppModel appModel = AppModel(
      strVersionName: packageInfo.version,
      strBuildNumber: packageInfo.buildNumber,
      strOS: Platform.operatingSystem,
      strOSVersion: Platform.operatingSystemVersion,
    );
    final result = await validityCheck.checkAndProceedToDataSource(
      appUpdateDataSource,
      data: appModel,
    );
    result.fold(
      (failure) {
        Utils.printLogs('Something went wrong $failure');
      },
      (loaded) {
        loaded.fold((f) {}, (r) async {
          _appUpdate = r as AppUpdateModel;
        });
      },
    );
    return _appUpdate;
  }

  void notifyAppUpdate(BuildContext context) async {
    _appUpdate ??= await _checkForAppFeatureForceUpdate();

    if (_appUpdate != null) {
      if (_appUpdate!.notifyUpdate) {
        if (SharedPreferencesManager.getString('latestVersion') != _appUpdate?.latestVersion) {
          SharedPreferencesManager.setString('latestVersion', _appUpdate?.latestVersion);
          SharedPreferencesManager.setBool('Skip', false);
        }
        if (!SharedPreferencesManager.getBool('Skip')) {
          AppManager.notifyAppUpdateDialog(context);
        }
      }
    }
  }

  MaterialPageRoute validateFeatureForceUpdate(
    RouteSettings settings,
    MaterialPageRoute pageRoute,
  ) {
    if (_appUpdate != null) {
      if (_appUpdate!.features.isNotEmpty) {
        if (_appUpdate!.features.contains(settings.name?.substring(1))) {
          return AppManager.showFatureForceUpdateDialog(settings.name!.substring(1));
        } else {
          return pageRoute;
        }
      }
    }
    return pageRoute;
  }

  List<Widget> validateDashbaordFeatureForceUpdate(List<Widget> pages, List<String> pageNames) {
    if (_appUpdate != null && _appUpdate!.features.isNotEmpty) {
      return List.generate(pages.length, (index) {
        final String pageName = pageNames[index];
        if (_appUpdate!.features.contains(pageName)) {
          return AppManager.showFeatureForceUpdateWidget();
        }
        return pages[index];
      });
    }
    return pages;
  }

  bool showForceUpdate(BuildContext context) {
    bool isTrue = false;
    if (_appUpdate != null) {
      if (_appUpdate!.forcedUpdate) {
        AppManager.showAppUpdateDiloag(context, isCancelButton: false);
        isTrue = true;
      }
    }
    return isTrue;
  }
}
