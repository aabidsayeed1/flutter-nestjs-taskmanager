// import 'dart:io';
// import 'package:gap/gap.dart';
// import 'package:task_manager/core/constants/app_colors.dart';
// import 'package:task_manager/core/constants/app_styles.dart';
// import 'package:task_manager/core/constants/app_values.dart';
// import 'package:task_manager/core/helpers/utils.dart';
// import 'package:task_manager/flavors.dart';
// import 'package:task_manager/injection_container.dart';
// import 'package:task_manager/route/custom_navigator.dart';
// import 'package:task_manager/route/global_navigator.dart';
// import 'package:task_manager/ui/atoms/button.dart';
// import 'package:task_manager/ui/custom_spacers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freerasp/freerasp.dart';

// class SecurityManager {
//   static final _callback = ThreatCallback(
//     onPrivilegedAccess: () {
//       Utils.printLogs("SecurityManager Privileged access");
//       _showSecurityDialog(
//         duration: 5,
//         canSkip: false,
//         message:
//             "This app does not support ${Platform.isAndroid ? "rooted" : "jailbroken"} devices. Please use the official version on a ${Platform.isAndroid ? "non-rooted" : "non-jailbroken"} device.",
//       );
//     },
//     onAppIntegrity: () {
//       Utils.printLogs("SecurityManager App integrity");
//       _showSecurityDialog(
//         canSkip: false,
//         duration: 5,
//         message:
//             "The application has detected unauthorized tampering. Access denied. Please reinstall the official version from the authorized source.",
//       );
//     },
//     onObfuscationIssues: () => Utils.printLogs("SecurityManager Obfuscation issues"),
//     onDebug: () => Utils.printLogs("SecurityManager Debugging"),
//     onDeviceBinding: () => Utils.printLogs("SecurityManager Device binding"),
//     onDeviceID: () => Utils.printLogs("SecurityManager Device ID"),
//     onHooks: () => Utils.printLogs("SecurityManager Hooks"),
//     onPasscode: () => Utils.printLogs("SecurityManager Passcode not set"),
//     onSecureHardwareNotAvailable:
//         () => Utils.printLogs("SecurityManager Secure hardware not available"),
//     onSimulator: () => Utils.printLogs("SecurityManager Simulator"),
//     onUnofficialStore: () => Utils.printLogs("SecurityManager Unofficial store"),
//   );
//   static Future initialise() async {
//     if ([Flavor.prod].contains(F.appFlavor) && !kDebugMode) {
//       //Todo: add your sha256Key below
//       const sha256Key =
//           '49:21:7C:1D:C8:87:A7:E9:94:1F:16:2A:81:20:2A:42:87:78:74:25:47:6C:DF:E4:11:3E:B6:AD:AB:31:E9:C7';
//       final signingCertHashes = hashConverter.fromSha256toBase64(sha256Key);
//       final config = TalsecConfig(
//         /// For Android
//         // androidConfig: AndroidConfig(
//         //   packageName: F.getAndroidPackageName,
//         //   signingCertHashes: [signingCertHashes],
//         //   supportedStores: [],
//         // ),

//         // /// For iOS
//         // iosConfig: IOSConfig(
//         //   bundleIds: [FlavorTypes.getIOSBundleId],
//         //   //Todo: add your team ID below
//         //   teamId: 'CU9MVGW56E',
//         // ),
//         watcherMail: '',
//         isProd: true,
//       );

//       Talsec.instance.attachListener(_callback);
//       await Talsec.instance.start(config);
//     }
//   }

//   static Future<dynamic> _showSecurityDialog({
//     Function()? onContinue,
//     String? title,
//     required String message,
//     bool canSkip = true,
//     int duration = 3,
//   }) async {
//     await Future.delayed(Duration(seconds: duration));
//     BuildContext? context = sl<NavigationService>().navigatorKey.currentContext;
//     if (context != null) {
//       await showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         isDismissible: false,
//         enableDrag: false,
//         useRootNavigator: true,
//         builder: (BuildContext context) {
//           return PopScope(
//             canPop: false,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.WHITE,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20.r),
//                   topRight: Radius.circular(20.r),
//                 ),
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Gap(4),
//                   Text(title ?? "Security Warning", style: AppStyles.titleStyle),
//                   Gap(16),
//                   Text(title ?? "Security Warning", style: AppStyles.titleStyle),
//                   Text(message, style: AppStyles.titleStyle),
//                   Gap(24),
//                   Text(title ?? "Security Warning", style: AppStyles.titleStyle),
//                   if (canSkip)
//                     Button(
//                       height: 55.h,
//                       width: double.infinity,
//                       strButtonText: canSkip ? "Continue" : "Close App",
//                       state: ButtonState.active,
//                       textStyle: AppStyles.buttonPrimaryDefaultNormal,
//                       size: ButtonSize.medium,
//                       buttonBackgroundColor: AppColors.LIGHTBOX_BACKGROUND,
//                       dCornerRadius: 60.r,
//                       buttonIconColor: AppColors.BLACK,
//                       buttonAction: () {
//                         if (canSkip) {
//                           if (onContinue != null) {
//                             onContinue();
//                           } else {
//                             CustomNavigator.pop(context);
//                           }
//                         } else {
//                           SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//                         }
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
// }
