import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_styles.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final TextStyle? textStyle;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style:
            textStyle?.copyWith(color: color ?? AppColors.primary800) ??
            AppStyles.bodySmallTextSmFontSemibold.copyWith(color: color ?? AppColors.primary800),
        textAlign: TextAlign.center,
      ),
    );
  }
}
