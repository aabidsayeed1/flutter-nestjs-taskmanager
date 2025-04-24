import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final TagSizes tagSize;
  final TagShape tagShape;
  final bool bIconRight;
  final Widget? icon;
  final bool bShowIcon;
  final TextStyle? tagTextStyle;
  final Color backgroundColor;
  final Color iconColor;
  final Function()? onClick;
  final double? dBorderRadius;
  final String strText;
  final double? dIconHeight;
  final double? dIconWidth;

  const Tag({
    Key? key,
    this.tagShape = TagShape.rounded,
    this.tagSize = TagSizes.Default,
    this.bIconRight = false,
    this.icon,
    this.bShowIcon = false,
    this.tagTextStyle,
    this.backgroundColor = AppColors.TAG_BACKGROUND_COLOR,
    this.iconColor = AppColors.TAG_ICON_COLOR,
    this.onClick,
    this.dBorderRadius,
    required this.strText,
    this.dIconHeight,
    this.dIconWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.TAG,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            dBorderRadius ??
                (tagShape == TagShape.rounded
                    ? AppValues.TAG_ROUNDED_RADIUS
                    : tagShape == TagShape.soft
                    ? AppValues.TAG_SOFT_RADIUS
                    : AppValues.TAG_SHARP_RADIUS),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bIconRight == false && bShowIcon) _icon(),
            if (bIconRight == false && bShowIcon) Gap(8),
            Flexible(
              child: Text(
                strText,
                style:
                    tagTextStyle ??
                    (tagSize == TagSizes.medium
                        ? AppStyles.tagMediumTextStyle
                        : tagSize == TagSizes.small
                        ? AppStyles.tagSmallTextStyle
                        : AppStyles.tagDefaultTextStyle),
              ),
            ),
            if (bIconRight && bShowIcon) Gap(8),
            if (bIconRight && bShowIcon) _icon(),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return GestureDetector(
      onTap: () {
        if (onClick != null) onClick!();
      },
      child: Image.asset(
        "assets/images/tag_cross_icon.png",
        color: iconColor,
        height:
            dIconHeight ??
            (tagSize == TagSizes.medium
                ? AppValues.TAG_ICON_MEDIUM_HEIGHT
                : tagSize == TagSizes.small
                ? AppValues.TAG_ICON_SMALL_HEIGHT
                : AppValues.TAG_ICON_DEFAULT_HEIGHT),
        width:
            dIconWidth ??
            (tagSize == TagSizes.medium
                ? AppValues.TAG_ICON_MEDIUM_WIDTH
                : tagSize == TagSizes.small
                ? AppValues.TAG_ICON_SMALL_WIDTH
                : AppValues.TAG_ICON_DEFAULT_WIDTH),
      ),
    );
  }
}
