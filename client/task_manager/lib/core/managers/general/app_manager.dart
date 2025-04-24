import 'dart:async';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/helpers/helper_file.dart';
// import 'package:task_manager/core/managers/firebase/firebase_remote_config.dart';
// import 'package:task_manager/core/managers/general/face_id_manager.dart';
// import 'package:task_manager/core/managers/firebase/firebase_manager.dart';
// import 'package:task_manager/core/managers/branch/branchio_manager.dart';
// import 'package:task_manager/core/managers/general/platform_manager_tuya.dart';
// import 'package:task_manager/core/managers/general/security_manager.dart';
import 'package:task_manager/injection_container.dart' as di;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:workmanager/workmanager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/apis/update/app_model.dart';
import 'package:task_manager/core/apis/update/get_app_update.dart';
import 'package:task_manager/ui/atoms/button.dart';
import 'package:store_redirect/store_redirect.dart';
import 'app_update_manager.dart';

// // @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await SharedPreferencesManager.init();

//     try {
//       switch (task) {
//         case "workManagerEvent":
//           {
//             Utils.printLogs("============================");
//             Utils.printLogs("workManagerEvent called");
//             Utils.printLogs("============================");

//             await LocationManager.sendLocationToServer();
//             await HiveHelper.initializeHive();
//             await ChecklistSyncManager.syncOfflineData();
//           }
//           break;
//       }
//     } catch (err) {
//       Utils.printLogs("workManagerEvent error");
//       throw Exception(err);
//     }
//     return Future.value(true);
//   });
// }

class AppManager {
  static Future<void> initialise() async {
    // await Firebase.initializeApp();
    // await FirebaseRemoteAppConfig.initialise();
    // await setupWorkManager();
    await di.init();
    await sl<CustomHttpClient>().initialise();
    // await SecurityManager.initialise();
    await SharedPreferencesManager.init();
    Utils.setBaseUrl(F.appBaseURL);
    await setupAppVersion();
    await AppUpdateManager.initialize();
    // await FirebaseManager.initialise();
    // await setupFirebase();
  }

  // static setupWorkManager() async {
  //   await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  //   await Workmanager().registerPeriodicTask("workManager", "workManagerEvent",
  //       constraints: Constraints(networkType: NetworkType.connected));
  // }

  static setupAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = "${packageInfo.version} (${packageInfo.buildNumber})";

    Utils.setAppVersion(version);
  }

  // static setupFirebase() async {
  //   await runZonedGuarded(
  //     () async {
  //       await FirebaseCrashlyticsManager.enableCrashlytics();
  //       FlutterError.onError = (FlutterErrorDetails flutterErrorDetails) async {
  //         FirebaseCrashlyticsManager.reportError(
  //           flutterErrorDetails.exception,
  //           flutterErrorDetails.stack,
  //         );
  //       };
  //     },
  //     (error, stackTrace) {
  //       FirebaseCrashlyticsManager.reportError(error, stackTrace);
  //     },
  //   );

  //   // Errros to be caught ouside the flutter context
  //   FirebaseCrashlyticsManager.reportErrorListener();
  // }

  static checkForAppUpdate(BuildContext context) async {
    GetAppUpdateDataSource instance = sl<GetAppUpdateDataSource>();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    AppModel appModel = AppModel(
      strVersionName: packageInfo.version,
      strBuildNumber: packageInfo.buildNumber,
      strOS: Platform.operatingSystem,
      strOSVersion: Platform.operatingSystemVersion,
    );
    bool bAppUpdateAvailable = await instance.getAppUpdate(appModel);

    if (bAppUpdateAvailable == true) {
      AppManager.showAppUpdateDiloag(context);
    }
  }

  static showFatureForceUpdateDialog(String routeName) {
    return MaterialPageRoute(
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 300), () {
          AppManager.showAppUpdateDiloag(context);
        });
        return Scaffold(
          backgroundColor: AppColors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Utils.getLocalizedString(
                  context,
                  'STRING_FEATURE_UPDATE_MESSAGE',
                  args: {"routeName": routeName},
                ),
                style: AppStyles.whiteBold16,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget showFeatureForceUpdateWidget() {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: AppColors.black,
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSpacers.height4,
                  Text(
                    (F.title +
                        Utils.getLocalizedString(context, 'STRING_UPDATE_TITLE')),
                    style: AppStyles.whiteBold16,
                    textAlign: TextAlign.left,
                  ),
                  CustomSpacers.height16,
                  Text(
                    'STRING_UPDATE_DESCRIPTION'.tr(),
                    style: AppStyles.whiteBold12,
                    textAlign: TextAlign.center,
                  ),
                  CustomSpacers.height24,
                  Button(
                    width: double.infinity,
                    size: ButtonSize.medium,
                    state: ButtonState.active,
                    buttonAction: () {
                      StoreRedirect.redirect(
                        androidAppId: AppStrings.BUNDLE_ANDROID_APP,
                        iOSAppId: AppStrings.BUNDLE_IOSAPP,
                      );
                    },
                    strButtonText: "STRING_UPDATE_c".tr(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static notifyAppUpdateDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      routeSettings: const RouteSettings(name: "forceupdate"),
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSpacers.height4,
              Text(
                (F.title + Utils.getLocalizedString(context, 'STRING_UPDATE_TITLE')),
                style: AppStyles.whiteBold16,
              ),
              CustomSpacers.height16,
              Text(
                Utils.getLocalizedString(context, 'STRING_NOTIFY_UPDATE_DESCRIPTION'),
                style: AppStyles.whiteBold12,
              ),
              CustomSpacers.height24,
              Row(
                children: [
                  Expanded(
                    child: Button(
                      height: 56.h,
                      padding: EdgeInsets.zero,
                      type: ButtonType.ghost,
                      strButtonText: "STRING_SKIP".tr(),
                      size: ButtonSize.medium,
                      state: ButtonState.active,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      textWidth: 160.w,
                      textStyle: AppStyles.bodyTextBaseFontSemiboldPrimary900,
                      buttonAction: () {
                        SharedPreferencesManager.setBool('Skip', true);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  CustomSpacers.width16,
                  Expanded(
                    child: Button(
                      height: 56.h,
                      padding: EdgeInsets.zero,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      textWidth: 160.w,
                      size: ButtonSize.medium,
                      state: ButtonState.active,
                      buttonAction: () {
                        StoreRedirect.redirect(
                          androidAppId: AppStrings.BUNDLE_ANDROID_APP,
                          iOSAppId: AppStrings.BUNDLE_IOSAPP,
                        );
                      },
                      strButtonText: "STRING_UPDATE_c".tr(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static showAppUpdateDiloag(BuildContext context, {isCancelButton = true, isSinglePop = false}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      routeSettings: const RouteSettings(name: "forceupdate"),
      useRootNavigator: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacers.height4,
                Text(
                  (F.title + Utils.getLocalizedString(context, 'STRING_UPDATE_TITLE')),
                  style: AppStyles.whiteBold16,
                ),
                CustomSpacers.height16,
                Text(
                  Utils.getLocalizedString(
                    context,
                    isCancelButton ? 'STRING_UPDATE_DESCRIPTION' : 'STRING_UPDATE_APP_DESCRIPTION',
                  ),
                  style: AppStyles.whiteBold12,
                ),
                CustomSpacers.height24,
                Row(
                  children: [
                    if (isCancelButton) ...[
                      Expanded(
                        child: Button(
                          height: 56.h,
                          padding: EdgeInsets.zero,
                          type: ButtonType.ghost,
                          strButtonText: "CANCEL_c".tr(),
                          size: ButtonSize.medium,
                          state: ButtonState.active,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          textWidth: 160.w,
                          textStyle: AppStyles.bodyTextBaseFontSemiboldPrimary900,
                          buttonAction: () {
                            Navigator.of(context).pop();
                            if (!isSinglePop) Navigator.of(context).pop();
                          },
                        ),
                      ),
                      CustomSpacers.width16,
                    ],
                    Expanded(
                      child: Button(
                        height: 56.h,
                        padding: EdgeInsets.zero,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        textWidth: 160.w,
                        size: ButtonSize.medium,
                        state: ButtonState.active,
                        buttonAction: () {
                          StoreRedirect.redirect(
                            androidAppId: AppStrings.BUNDLE_ANDROID_APP,
                            iOSAppId: AppStrings.BUNDLE_IOSAPP,
                          );
                        },
                        strButtonText: "STRING_UPDATE_c".tr(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
