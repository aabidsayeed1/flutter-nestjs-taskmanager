import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertMessages extends StatelessWidget {
  final String strAlertMessage;
  final double dCornerradius;
  final String? strIconData;
  final AlertTypes alertTypes;
  final double dAlertBoxHeight;

  const AlertMessages({
    Key? key,
    required this.strAlertMessage,
    this.strIconData = "",
    this.dAlertBoxHeight = AppValues.ALERT_MESSAGES_BOX_HEIGHT,
    this.dCornerradius = AppValues.ALERT_MESSAGES_CORNER_RADIUS,
    required this.alertTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ALERT_MESSAGES,
      child: Container(
        height: dAlertBoxHeight,
        padding: const EdgeInsets.only(left: 18),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.bgColorForAlert(alertTypes)),
          borderRadius: BorderRadius.circular(dCornerradius),
          color: AppColors.bgColorForAlert(alertTypes),
        ),
        child: Row(
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: AppValues.ALERT_IMAGE_HEIGHT,
                width: AppValues.ALERT_IMAGE_WIDTH,
                child: imageForAlertType(alertTypes, strIconData!),
              ),
            ),
            Flexible(
              child: Text(
                strAlertMessage,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.alertTextStyle(
                  cAlertTextColor: AppColors.alertTextColor(alertTypes),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageForAlertType(AlertTypes alertTypes, String strIconData) {
    switch (alertTypes) {
      case AlertTypes.Error:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.ERROR_ICON)
            : SvgPicture.asset(strIconData);
      case AlertTypes.ErrorLight:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.ERROR_LIGHT_ICON)
            : SvgPicture.asset(strIconData);
      case AlertTypes.Info:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.INFO_ICON)
            : SvgPicture.asset(strIconData);
      case AlertTypes.InfoLight:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.INFO_BLUE_ICON)
            : SvgPicture.asset(strIconData);
      case AlertTypes.Success:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.SUCCESS_ICON)
            : SvgPicture.asset(strIconData);
      case AlertTypes.SuccessLight:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.SUCCESS_LIGHT_ICON)
            : SvgPicture.asset(strIconData);
      case AlertTypes.Warning:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.WARNING_ICON)
            : SvgPicture.asset(strIconData);
      case AlertTypes.WarningLight:
        return strIconData == ""
            ? SvgPicture.asset(AppImages.WARNING_LIGHT_ICON)
            : SvgPicture.asset(strIconData);
    }
  }
}
