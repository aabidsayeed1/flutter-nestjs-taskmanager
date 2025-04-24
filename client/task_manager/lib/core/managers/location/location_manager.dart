// import 'dart:async';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:task_manager/app_imports.dart';
// import 'package:task_manager/core/helpers/helper_file.dart';
// // import 'package:task_manager/core/apis/location/send_location.dart';
// import 'package:task_manager/ui/atoms/button.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:permission_handler/permission_handler.dart';

// class LocationManager {
//   static Timer? timer;
//   static bool hasPermanentlyDenied = false;
//   static bool permissionGiven = false;

//   static geo.Position? _position;
//   static Function? callbackFunction;
//   static void setLocation() async {
//     // geo.Position position = await geo.Geolocator.getCurrentPosition();
//     // setLocationLatitude(position.latitude);
//     // setLocationLongitude(position.longitude);
//   }

//   // static setLocationLatitude(double dLatitude) {
//   //   SharedPreferencesManager.setDouble(AppStrings.USER_LATITUDE, dLatitude);
//   // }

//   // static setLocationLongitude(double dLatitude) {
//   //   SharedPreferencesManager.setDouble(AppStrings.USER_LONGITUDE, dLatitude);
//   // }

//   // static double getSavedLocationLatitude() {
//   //   return SharedPreferencesManager.getDouble(AppStrings.USER_LATITUDE);
//   // }

//   // static double getSavedLocationLongitude() {
//   //   return SharedPreferencesManager.getDouble(AppStrings.USER_LONGITUDE);
//   // }

//   // static Future<geo.Position> getCurrentLocation() async {
//   //   _position ??= await geo.Geolocator.getCurrentPosition();
//   //   return _position!;
//   // }

//   static Future<dynamic> getCurrentLocationDetails() async {
//     _position ??= await geo.Geolocator.getCurrentPosition();
//     if (_position != null) {
//       return {"lat": _position!.latitude, "long": _position!.longitude};
//     } else {
//       return {"lat": 0.0, "long": 0.0};
//     }
//   }

//   static Future<void> askForChangingPermission({Function? callback}) async {
//     hasPermanentlyDenied = false;

//     if (await openAppSettings()) {
//       callbackFunction = callback;
//     }
//   }

//   // static Future<bool> islocationPermisionGranted() async {
//   //   final status = await Permission.locationWhenInUse.status;
//   //   return status == PermissionStatus.granted || status == PermissionStatus.limited;
//   // }
//   static Future<bool> islocationPermisionGranted() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   static Future<bool> checkForPermission(BuildContext context) async {
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
//         return true;
//       }
//     }

//     if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
//       return true;
//     }
//     if (permission == LocationPermission.deniedForever) {
//       _openLocationSettings(context, true);
//       return false;
//     }
//     return false;
//   }

//   static Future<void> _openLocationSettings(BuildContext context, bool isOpenAppSeeting) async {
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
//           heightFactor: 0.6,
//           child: Container(
//             decoration: BoxDecoration(
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
//                               "STRING_ENABLE_LOCATION_PERMISSION".tr(),
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
//                         "STRING_ENABLE_LOCATION_PERMISSION_MESSAGE".tr(),
//                         style: AppStyles.bodyTextBaseFontNormal,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     padding: EdgeInsets.only(top: 16.h, bottom: 28.h),
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
//                           strButtonText: "STRING_CANCEL".tr(),
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
//                             Navigator.pop(context);
//                             await Geolocator.openAppSettings();
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
//   // static Future<bool> checkForPermission(BuildContext context) async {
//   //   ServiceStatus serviceStatus = await Permission.locationWhenInUse.serviceStatus;

//   //   if (serviceStatus.isEnabled) {
//   //     var status = await Permission.locationWhenInUse.status;
//   //     if (status.isDenied) {
//   //       var reqStatus = await Permission.locationWhenInUse.request();
//   //       return await _handlePermissionRequest(reqStatus);
//   //     } else {
//   //       return await _handlePermissionRequest(status);
//   //     }
//   //   } else {
//   //     showLocationEntryPopup("Location services are disabled");
//   //     return false;
//   //   }
//   // }

//   // static Future<bool> _handlePermissionRequest(PermissionStatus status) async {
//   //   if (status.isDenied) {
//   //     permissionGiven = false;
//   //     return false;
//   //   } else if (status.isPermanentlyDenied) {
//   //     permissionGiven = false;
//   //     hasPermanentlyDenied = true;
//   //     askedForChangingPermission(callback: () {});
//   //     return false;
//   //   } else if (status.isGranted || status.isLimited) {
//   //     await _onPermissionGranted();
//   //     return true;
//   //   }
//   //   return false;
//   // }

//   // static Future<void> _onPermissionGranted() async {
//   //   permissionGiven = true;
//   //   if (callbackFunction != null) {
//   //     await callbackFunction!();
//   //     callbackFunction = null;
//   //   }
//   // }

//   // static Future<geo.Position> getCurrentLocation() async {
//   //   _position ??= await geo.Geolocator.getCurrentPosition();
//   //   return _position!;
//   // }

//   static askedForChangingPermission({Function? callback}) async {
//     hasPermanentlyDenied = false;

//     if (await openAppSettings()) {
//       callbackFunction = callback;
//     }
//   }

//   // static Future<bool> checkForPermission(BuildContext context) async {
//   //   ServiceStatus serviceStatus = await Permission.locationWhenInUse.serviceStatus;

//   //   if (serviceStatus.isEnabled) {
//   //     var status = await Permission.locationWhenInUse.status;

//   //     if (status.isDenied) {
//   //       permissionGiven = false;
//   //       var reqStatus = await Permission.locationWhenInUse.request();
//   //       return _handlePermissionRequest(reqStatus);
//   //     } else {
//   //       return _handlePermissionRequest(status);
//   //     }
//   //   } else {
//   //     return Future.error('Location disabled');
//   //   }
//   // }

//   // static _handlePermissionRequest(PermissionStatus status) async {
//   //   if (status.isDenied) {
//   //     permissionGiven = false;
//   //     return Future.error('Location permissions are denied');
//   //   } else if (status.isPermanentlyDenied) {
//   //     permissionGiven = false;
//   //     hasPermanentlyDenied = true;
//   //     return Future.error(
//   //         'Location permissions are permanently denied, we cannot request permissions.');
//   //   } else if (status.isGranted || status.isLimited) {
//   //     _onPermissionGranted();
//   //   }
//   // }

//   // static _onPermissionGranted() async {
//   //   permissionGiven = true;
//   //   if (callbackFunction != null) {
//   //     await callbackFunction!();
//   //     callbackFunction = null;
//   //   }
//   // }

//   static Widget showLocationEntryPopup(String strErrorMessage) {
//     if (strErrorMessage.isEmpty) {}

//     return AlertDialog(
//       title: Column(
//         children: <Widget>[
//           Text(
//             strErrorMessage.isNotEmpty
//                 ? strErrorMessage
//                 : "Location not set. Please set the location",
//             style: AppStyles.messageStyle,
//           ),
//           CustomSpacers.height10,
//           if (strErrorMessage.isEmpty)
//             Button(
//               buttonAction: () {
//                 setLocation();
//               },
//               type: ButtonType.primary,
//               size: ButtonSize.small,
//               state: ButtonState.Default,
//               strButtonText: "Set Location",
//             ),
//         ],
//       ),
//     );
//   }

//   // static Future<bool> isLocationPermissionGiven() async {
//   //   LocationPermission permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied ||
//   //       permission == LocationPermission.deniedForever) {
//   //     Utils.printLogs("Location permisison is not given");
//   //   }

//   //   return true;
//   // }

//   static sendLocationToServer() async {
//     // try {
//     //   bool isLocationEnabled = await geo.Geolocator.isLocationServiceEnabled();
//     //   if (isLocationEnabled) {
//     //     geo.Position pos = await LocationManager.getCurrentLocation();
//     //     SendLocationDataSource instance = SendLocationDataSource();
//     //     String flavour = Utils.getBaseUrl();
//     //     String strURL =
//     //         "$flavour${AppUrls.USER_DETAILS}/${HelperUser.getUserId()}/${AppUrls.CURRENT_LCOATION_ENDPOINT}";

//     //     await instance.sendLocation(
//     //         strUserId: HelperUser.getUserId(),
//     //         dLatitude: pos.latitude,
//     //         dLongitude: pos.longitude,
//     //         url: strURL);
//     //   }
//     // } catch (exception) {
//     //   Utils.printLogs("error printing $exception");
//     // }
//   }
// }
