import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/app_widgets/atoms/custom_text_field.dart';
import 'package:task_manager/ui/atoms/image_view.dart';

class CustomSelectableTextField extends StatelessWidget {
  const CustomSelectableTextField({
    super.key,
    required this.onTap,
    required this.controller,
    required this.hintText,
    this.isDisable = true,
    this.onChanged,
    this.focusNode,
  });
  final VoidCallback onTap;
  final TextEditingController controller;
  final String hintText;
  final bool isDisable;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomTextField(
        onChanged: onChanged,
        disabled: isDisable,
        controller: controller,
        focusNode: focusNode,
        hint: hintText,
        hintStyle: AppStyles.bodyTextBaseFontNormalNeutral500,
        suffix: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: ImageView(
              height: 16.r,
              width: 16.r,
              strIconData: AppImages.STRING_ICON_ARROW_DOWN,
            ),
          ),
        ),
      ),
    );
  }
}
