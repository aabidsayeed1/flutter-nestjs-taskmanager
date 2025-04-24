import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/helpers/helper_file.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';
import 'package:task_manager/core/managers/general/overlay_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:task_manager/core/managers/location/location_manager.dart';
import 'package:task_manager/ui/atoms/button.dart';
import 'package:task_manager/ui/atoms/image_view.dart';
import 'package:shimmer/shimmer.dart';

class HelperUI {
  static Widget emptyContainer() {
    // ignore: sized_box_for_whitespace
    return Container(width: 0, height: 0);
  }

  static ColorFilter getSVGCOlor(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  static showToast({
    required String msg,
    required ToastType type,
    ToastDuration duration = ToastDuration.medium,
  }) {
    OverlayManager.showToast(type: type, msg: msg, duration: duration);
  }
  static showLoader({double opacity = 0.02, Color color = Colors.white}) async {
    if (await InternetConnectionChecker.instance.hasConnection) {
      OverlayManager.showLoader(opacity: opacity, color: color);
      //20 ms delay for postFrameCallback scheduling
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  static showTextLoader({
    double opacity = 0.25,
    Color color = Colors.white,
    String text = "",
  }) async {
    OverlayManager.showLoaderWText(opacity: opacity, color: color, text: text);

    //20 ms delay for postFrameCallback scheduling
    await Future.delayed(const Duration(milliseconds: 20));
  }

  static hideLoader() {
    OverlayManager.hideOverlay();
  }

  static Widget getProgressIndicator() {
    return Material(
      color: Colors.white.withOpacity(0.6),
      child: const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(color: AppColors.APP_THEME),
        ),
      ),
    );
  }



  static Widget getProgressGhost({height = 0.0, width = 0.0}) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: AppColors.APP_THEME,
        highlightColor: AppColors.APP_THEME,
        period: const Duration(seconds: 2),
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(color: AppColors.APP_THEME),
        ),
      ),
    );
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static void navigateTologin(BuildContext context) {
    SharedPreferencesManager.setString(AppStrings.USER_ID, '');
    SharedPreferencesManager.setString(AppStrings.USER_TOKEN, '');
    SharedPreferencesManager.setString(AppStrings.USER_NAME, '');
    CustomNavigator.popUntilFirstAndPush(context, AppPages.PAGE_LOGIN);
  }

  static showSnackBar({String? strTile, required String strMessage}) {}

  static Future<String?> showBottomSheet(
    BuildContext context,
    String value,
    List<String> items, {
    double heightFactor = 0.6,
    List<String>? subtitle,
    List<String>? icons,
    VoidCallback? onAddManually,
    String? manuallyText = "STRING_CANT_FIND_DEVICE",
  }) async {
    if (onAddManually != null) {
      heightFactor = heightFactor + 0.14;
    }
    return await showModalBottomSheet<String>(
      backgroundColor: AppColors.grayBgContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: Navigator.of(context),
      ),
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: heightFactor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              border: Border(top: BorderSide(color: AppColors.borderColor, width: 1.r)),
            ),
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(top: 24.h),
                  children: [
                    ...items.map((item) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        selectedTileColor: AppColors.black,
                        selectedColor: AppColors.black,
                        selected: item == value,
                        title: Text(
                          item,
                          style: AppStyles.bodySmallTextSmFontNormal.copyWith(
                            color:
                                'STRING_DELETE_DEVICE'.tr() == item
                                    ? AppColors.semanticTextFeildError
                                    : null,
                          ),
                        ),
                        trailing:
                            icons != null
                                ? SizedBox(
                                  height: 23.r,
                                  width: 23.r,
                                  child: ImageView(strIconData: icons[items.indexOf(item)]),
                                )
                                : null,
                        subtitle:
                            subtitle != null
                                ? Text(
                                  subtitle[items.indexOf(item)],
                                  style: AppStyles.bodySmallTextSmFontNormalNeutral400,
                                )
                                : null,
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      );
                    }).toList(),
                    if (items.isEmpty)
                      Center(child: Lottie.asset(height: 200.h, AppImages.STRING_LOTTIE_EMPTY_BOX)),
                    if (onAddManually != null) Gap(100.h),
                  ],
                ),
                if (onAddManually != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 16.h, bottom: 28.h),
                      decoration: BoxDecoration(
                        color: AppColors.grayBgContainer,
                        border: Border(top: BorderSide(color: AppColors.borderColor, width: 1.r)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        selectedTileColor: AppColors.black,
                        selectedColor: AppColors.black,
                        title: Text(manuallyText!.tr(), style: AppStyles.bodySmallTextSmFontNormal),
                        trailing: SizedBox(
                          width: 174.w,
                          height: 56.h,
                          child: Button(
                            padding: EdgeInsets.zero,
                            type: ButtonType.ghost,
                            width: double.infinity,
                            strButtonText: "STRING_ADD_MANUALLY".tr(),
                            size: ButtonSize.small,
                            state: ButtonState.active,
                            textWidth: 165.w,
                            maxLines: 2,
                            textStyle: AppStyles.bodyTextBaseFontSemiboldPrimary900,
                            buttonAction: onAddManually,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showAppModalBottomSheet({
    required BuildContext context,
    required Widget child,
    bool bIsDismissible = true,
    bool isScrollControlled = true,
    bool isPadding = false,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: bIsDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: isPadding ? MediaQuery.of(context).viewInsets : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: double.infinity, color: AppColors.grayBgContainer, child: child),
            ],
          ),
        );
      },
    );
  }

  static showProfileDialog(BuildContext context, String strProfileURL) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: Utils.getScreenHeight(context) * 0.4,
            width: Utils.getScreenWidth(context) * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.borderColor, width: 1.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: ImageView(strIconData: strProfileURL),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: EdgeInsets.only(top: 16.h, right: 10.w),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.pop(context),
                    icon: CircleAvatar(
                      backgroundColor: AppColors.grayBgContainer.withOpacity(0.7),
                      child: const Icon(Icons.close, color: AppColors.WHITE),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget profileWidget(
    BuildContext context,
    int nValue,
    String strProfileURL, {
    int nDefaultValue = 40,
  }) {
    return Container(
      height: nValue.r,
      width: nValue.r,
      decoration: BoxDecoration(
        color: AppColors.grayBgDevices,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child:
          (strProfileURL.isNotEmpty)
              ? GestureDetector(
                onTap: () => HelperUI.showProfileDialog(context, strProfileURL),
                child: ImageView(
                  height: nValue.r,
                  width: nValue.r,
                  dBorderRadius: nValue.r,
                  shape: ImageShapes.Circle,
                  strIconData: strProfileURL,
                ),
              )
              : Icon(Icons.person, size: nDefaultValue.r),
    );
  }

  static Widget createRevokeLinkBottomSheet(
    BuildContext context,
    StateSetter addonModalSetState,
    String strInviteId,
    Function callBack,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("STRING_REVOKE_LINK".tr(), style: AppStyles.h5TextXlFontSemibold),
              GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child: const Icon(Icons.close),
              ),
            ],
          ),
          CustomSpacers.height30,
          Text('STRING_REVOKE_INVITATION_MESSAGE'.tr(), style: AppStyles.bodyTextBaseFontNormal),
          CustomSpacers.height30,
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 32.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Button(
                  type: ButtonType.ghost,
                  width: 170.w,
                  strButtonText: "STRING_NO".tr(),
                  size: ButtonSize.medium,
                  state: ButtonState.active,
                  buttonAction: () {
                    Navigator.pop(context);
                  },
                ),
                Button(
                  width: 170.w,
                  strButtonText: "STRING_YES_REVOKE".tr(),
                  size: ButtonSize.medium,
                  state: ButtonState.active,
                  buttonAction: () {
                    callBack(strInviteId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


 

  static showAlertDialogWithMessageAndOkButton(BuildContext context, String strMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.grayBgContainer,
          child: Container(
            height: 200.h,
            width: Utils.getScreenWidth(context) * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.borderColor, width: 1.r),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(strMessage, style: AppStyles.bodySmallTextSmFontNormal),
                  CustomSpacers.height20,
                  Button(
                    width: double.infinity,
                    strButtonText: "STRING_OKAY".tr(),
                    size: ButtonSize.small,
                    state: ButtonState.active,
                    buttonAction: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
