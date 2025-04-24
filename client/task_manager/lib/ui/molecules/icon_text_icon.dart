import 'package:task_manager/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_values.dart';
import '../automation_constants.dart';
import '../custom_spacers.dart';

class IconTextIcon extends StatelessWidget {
  final String strText;
  final TextStyle styleText;
  final String strLeftIconName;
  final Color colorLeftIcon;
  final String strRightIconName;
  final Color colorRightIcon;
  final Color colorBorder;
  final double dBorderRadius;
  final Color colorBase;
  final EdgeInsets dPadding;
  final double dIconSize;
  final bool showBorder;
  final bool useMaxSpace;
  final int? nNumberOfLines;
  final CrossAxisAlignment crossAxisAlignment;

  const IconTextIcon({
    Key? key,
    required this.strText,
    this.strLeftIconName = '',
    this.strRightIconName = '',
    this.colorBorder = AppColors.ICON_TEXT_ICON_BORDER,
    this.colorLeftIcon = AppColors.ICON_TEXT_ICON_LEFT_ICON,
    this.colorRightIcon = AppColors.ICON_TEXT_ICON_RIGHT_ICON,
    this.dBorderRadius = AppValues.ICON_TEXT_ICON_BORDER_RADIUS,
    this.colorBase = AppColors.ICON_TEXT_ICON_BASE,
    this.dIconSize = AppValues.ICON_TEXT_ICON_ICON_SIZE,
    this.showBorder = false,
    this.useMaxSpace = false,
    this.dPadding = const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
    this.styleText = AppStyles.styleText,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.nNumberOfLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ICON_TEXT_ICON,
      child: Container(
        decoration:
            showBorder
                ? BoxDecoration(
                  border: Border.all(color: colorBorder, width: 1),
                  borderRadius: BorderRadius.circular(dBorderRadius),
                  color: colorBase,
                )
                : null,
        child: Padding(
          padding: dPadding,
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            children: <Widget>[
              if (strLeftIconName.isNotEmpty)
                Image.asset(
                  strLeftIconName,
                  color: colorLeftIcon,
                  width: dIconSize,
                  height: dIconSize,
                ),
              if (strLeftIconName.isNotEmpty) CustomSpacers.width8,
              if (nNumberOfLines != null)
                Expanded(
                  child: Text(
                    strText,
                    style: styleText,
                    maxLines: nNumberOfLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (nNumberOfLines == null) Text(strText, style: styleText),
              if (strRightIconName.isNotEmpty && !useMaxSpace) CustomSpacers.width4,
              if (strRightIconName.isNotEmpty && useMaxSpace) const Spacer(),
              if (strRightIconName.isNotEmpty)
                Image.asset(
                  strRightIconName,
                  color: colorRightIcon,
                  width: dIconSize,
                  height: dIconSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
