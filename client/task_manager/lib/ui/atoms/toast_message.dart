import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class ToastMessage extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final double borderRadius;
  final IconData icon;
  final Color iconColor;
  final double? iconSize;
  final TextStyle? style;
  final EdgeInsets? padding;
  const ToastMessage({
    Key? key,
    required this.text,
    this.textColor = AppColors.TOAST_MESSAGE_TEXT_COLOR,
    this.bgColor = AppColors.TOAST_MESSAGE_BG_COLOR,
    this.borderRadius = AppValues.TOAST_MESSAGE_BORDER_RADIUS,
    this.icon = Icons.check,
    this.iconColor = AppColors.TOAST_MESSAGE_ICON_COLOR,
    this.iconSize,
    this.style,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.TOAST_MESSAGE,
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 21.7, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: iconSize ?? 20.0,
            ),
            const SizedBox(
              width: 13.83,
            ),
            Expanded(
              child: Text(
                text,
                style: style ?? AppStyles.toastMessageStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
