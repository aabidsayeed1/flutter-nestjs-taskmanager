// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:task_manager/app_imports.dart';
// import 'package:task_manager/core/helpers/helper_file.dart';
// import 'package:task_manager/ui/atoms/button.dart';
// import '../firebase/firebase_fcm_manager.dart';

// class NotificationPermissionHandler {
//   static Future<bool> checkPermissionAndProceed(BuildContext context, String page) async {
//     final status = await Permission.notification.status;

//     if (status.isGranted) {
//       FirebaseFCMManger().registerNotification();
//       if (page.isEmpty) return true;
//       await CustomNavigator.pushTo(context, page);
//     } else if (status.isDenied || status.isPermanentlyDenied) {
//       return _requestNotificationPermission(context, page);
//     }
//     return false;
//   }

//   static Future<bool> _requestNotificationPermission(BuildContext context, String page) async {
//     final result = await Permission.notification.request();

//     if (result.isGranted) {
//       FirebaseFCMManger().registerNotification();
//       if (page.isEmpty) return true;
//       await CustomNavigator.pushTo(context, page);
//     } else if (result.isPermanentlyDenied) {
//       await _showBottomSheet(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Notification permission is required to proceed.")),
//       );
//     }
//     return false;
//   }

//   static Future<void> _showBottomSheet(BuildContext context) async {
//     showModalBottomSheet<String>(
//       backgroundColor: AppColors.grayBgContainer,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.r),
//           topRight: Radius.circular(20.r),
//         ),
//       ),
//       transitionAnimationController: AnimationController(
//         duration: const Duration(milliseconds: 500),
//         vsync: Navigator.of(context),
//       ),
//       context: context,
//       builder: (BuildContext context) {
//         return FractionallySizedBox(
//           heightFactor: 0.63,
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.grayBgContainer,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20.r),
//                 topRight: Radius.circular(20.r),
//               ),
//               border: Border(top: BorderSide(color: AppColors.borderColor, width: 1.r)),
//             ),
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'STRING_ENABLE_NOTIFICATION_PERMISSIONS'.tr(),
//                               style: AppStyles.h5TextXlFontSemibold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           IconButton(
//                             visualDensity: VisualDensity.compact,
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.close),
//                           ),
//                         ],
//                       ),
//                       Gap(24.h),
//                       Text(
//                         'STRING_ENABLE_NOTIFICATION_PERMISSION_MESSAGE'.tr(),
//                         style: AppStyles.bodyTextBaseFontNormal,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     padding: EdgeInsets.only(top: 16.h, bottom: 50),
//                     decoration: BoxDecoration(
//                       color: AppColors.grayBgContainer,
//                       border: Border(top: BorderSide(color: AppColors.borderColor, width: 1.r)),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
//                       selectedTileColor: AppColors.black,
//                       selectedColor: AppColors.black,
//                       leading: SizedBox(
//                         width: 174.w,
//                         height: 56.h,
//                         child: Button(
//                           type: ButtonType.ghost,
//                           width: double.infinity,
//                           strButtonText: "CANCEL_c".tr(),
//                           size: ButtonSize.small,
//                           state: ButtonState.active,
//                           textStyle: AppStyles.bodyTextBaseFontSemiboldPrimary900,
//                           buttonAction: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       trailing: SizedBox(
//                         width: 174.w,
//                         height: 56.h,
//                         child: Button(
//                           type: ButtonType.primary,
//                           width: double.infinity,
//                           strButtonText: "STRING_ENABLE".tr(),
//                           size: ButtonSize.small,
//                           state: ButtonState.active,
//                           textStyle: AppStyles.bodyTextBaseFontSemibold,
//                           buttonAction: () async {
//                             Navigator.of(context).pop();
//                             await openAppSettings();
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
