import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/managers/general/overlay_manager.dart';
import 'package:task_manager/ui/atoms/image_view.dart';
import 'package:flutter/material.dart';

class ToastThemeColor {
  final Color backGroundColor;
  final Color color;
  ToastThemeColor({required this.backGroundColor, required this.color});
}

class ToastWidget extends StatelessWidget {
  final String title;
  final ToastType type;

  const ToastWidget({Key? key, this.title = "SUCCESS", required this.type}) : super(key: key);

  ToastThemeColor _getToastTheme(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastThemeColor(
          backGroundColor: AppColors.TOAST_SUCCESS_BACKGROUND,
          color: AppColors.TOAST_SUCCESS,
        );
      case ToastType.error:
        return ToastThemeColor(
          backGroundColor: AppColors.TOAST_ERROR_BACKGROUND,
          color: AppColors.TOAST_ERROR,
        );
      case ToastType.alert:
        return ToastThemeColor(
          backGroundColor: AppColors.TOAST_ALERT_BACKGROUND,
          color: AppColors.TOAST_ALERT,
        );
      case ToastType.information:
        return ToastThemeColor(
          backGroundColor: AppColors.TOAST_INFORMATION_BACKGROUND,
          color: AppColors.TOAST_INFORMATION,
        );
      default:
        return ToastThemeColor(
          backGroundColor: AppColors.TOAST_INFORMATION_BACKGROUND,
          color: AppColors.TOAST_INFORMATION,
        );
    }
  }

  _getToastIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return AppImages.TOAST_SUCCESS_ICON;
      case ToastType.error:
        return AppImages.ERROR_TOAST_ICON;
      case ToastType.information:
        return AppImages.INFORMATION_TOAST_ICON;
      case ToastType.alert:
        return AppImages.ALERT_TOAST_ICON;
      default:
        return AppImages.GREEN_TICK_BIG;
    }
  }

  Widget _toastTitle(BuildContext context) {
    return Row(
      children: [
        AbsorbPointer(
          child: ImageView(
            strIconData: _getToastIcon(type),
            shape: ImageShapes.File,
            clickAction: () {},
          ),
        ),
        // Icon(Icons.info, color: _getToastTheme(type).color, size: 20),
        const SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.68,
          child: Text(
            title,
            style: AppStyles.toastMessageStyle.copyWith(color: _getToastTheme(type).color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              color: _getToastTheme(type).backGroundColor,
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  _toastTitle(context),
                  // const Icon(
                  //   Icons.close_rounded,
                  //   size: 12,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
