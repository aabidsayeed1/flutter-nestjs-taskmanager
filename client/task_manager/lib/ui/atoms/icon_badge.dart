import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final Widget icon;
  final String? strBadgeText;
  final Color? badgeColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final bool bIsBadgeVisible;
  final EdgeInsetsGeometry? padding;

  const IconBadge({
    Key? key,
    required this.icon,
    this.strBadgeText,
    this.badgeColor = AppColors.ICON_BADGE_COLOR,
    this.textColor = AppColors.ICON_BADGE_TEXT_COLOR,
    this.textStyle,
    this.bIsBadgeVisible = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ICONBADGE,
      child: Badge(
        backgroundColor: badgeColor,
        textColor: textColor,
        textStyle: textStyle,
        isLabelVisible: bIsBadgeVisible,
        padding: padding,
        label: Text(strBadgeText ?? ""),
        child: icon,
      ),
    );
  }
}
