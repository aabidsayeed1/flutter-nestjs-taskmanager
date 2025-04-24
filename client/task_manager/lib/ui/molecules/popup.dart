import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/atoms/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PopUp extends StatelessWidget {
  final PopUpTypes popUpType;
  final String title;
  final String content;
  final Widget? icon;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;

  const PopUp({
    Key? key,
    required this.popUpType,
    required this.title,
    required this.content,
    this.icon,
    this.titleTextStyle,
    this.contentTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 8),
      titleTextStyle: titleTextStyle ?? AppStyles.popupTitleTextStyle,
      title: Row(
        children: [
          SizedBox(width: 20, child: icon ?? iconForPopUpType(popUpType)),
          const SizedBox(width: 18),
          Flexible(child: Text(title, style: titleTextStyle ?? AppStyles.popupTitleTextStyle)),
        ],
      ),
      contentPadding: const EdgeInsets.only(left: 68, right: 32),
      contentTextStyle: contentTextStyle ?? AppStyles.popupContentTextStyle,
      content: Row(
        children: [
          //const SizedBox(width: 40),
          Flexible(
            child: Text(content, style: contentTextStyle ?? AppStyles.popupContentTextStyle),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      actions: <Widget>[
        if (popUpType == PopUpTypes.Delete)
          Button(
            buttonAction: () {
              Navigator.pop(context, 'OK');
            },
            type: ButtonType.ghost,
            size: ButtonSize.extraSmall,
            state: ButtonState.Default,
            strButtonText: "No",
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          ),
        Button(
          buttonAction: () {
            Navigator.pop(context, 'OK');
          },
          type: ButtonType.primary,
          size: ButtonSize.extraSmall,
          state: ButtonState.Default,
          strButtonText: "Yes",
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ),
      ],
    );
  }

  Widget iconForPopUpType(PopUpTypes popUpType) {
    switch (popUpType) {
      case PopUpTypes.Delete:
        return SvgPicture.asset(
          AppImages.POPUP_INFO_REVERT_ICON,
          colorFilter: HelperUI.getSVGCOlor(AppColors.POPUP_WARNING_BASE),
          // color: AppColors.POPUP_WARNING_BASE,
          height: 20,
          width: 20,
        );

      case PopUpTypes.Info:
        return SvgPicture.asset(
          AppImages.POPUP_INFO_ICON,
          colorFilter: HelperUI.getSVGCOlor(AppColors.POPUP_INFO_BASE),
          //color: AppColors.POPUP_INFO_BASE,
          height: 20,
          width: 20,
        );

      case PopUpTypes.Error:
        return SvgPicture.asset(
          AppImages.POPUP_ERROR_ICON,
          colorFilter: HelperUI.getSVGCOlor(AppColors.POPUP_ERROR_BASE),
          //color: AppColors.POPUP_ERROR_BASE,
          height: 20,
          width: 20,
        );

      case PopUpTypes.Warning:
        return SvgPicture.asset(
          AppImages.POPUP_WARNING_ICON,
          colorFilter: HelperUI.getSVGCOlor(AppColors.POPUP_WARNING_BASE),
          //color: AppColors.POPUP_WARNING_BASE,
          height: 20,
          width: 20,
        );

      case PopUpTypes.Success:
        return SvgPicture.asset(
          AppImages.POPUP_SUCCESS_ICON,
          colorFilter: HelperUI.getSVGCOlor(AppColors.POPUP_SUCCESS_BASE),
          //color: AppColors.POPUP_SUCCESS_BASE,
          height: 20,
          width: 20,
        );
    }
  }
}
