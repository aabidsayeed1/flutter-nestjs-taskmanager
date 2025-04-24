import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final bool autofocus;
  final Color borderColor;
  final Color hoverColor;
  final Color focusColor;
  final Color cursorColor;
  final Color labelStyleColor;
  final Color hintStyleColor;
  final bool labelTextFlag;
  final String labelText;
  final Color colorBg;
  final bool readOnly;
  final double borderRadius;
  final double labelStyleFontSize;

  const Input({
    super.key,
    this.placeholder = "",
    this.suffixIcon,
    this.prefixIcon,
    this.autofocus = false,
    this.borderColor = AppColors.INPUT_FIELD_BORDER_COLOR,
    this.colorBg = AppColors.INPUT_FIELD_BG_COLOR,
    this.focusColor = AppColors.INPUT_FIELD_FOCUS_COLOR,
    this.hoverColor = AppColors.INPUT_FIELD_HOVER_COLOR,
    this.cursorColor = AppColors.INPUT_FIELD_CURSOR_COLOR,
    this.labelStyleColor = AppColors.INPUT_FIELD_LABEL_STYLE_COLOR,
    this.hintStyleColor = AppColors.INPUT_FIELD_HINT_STYLE_COLOR,
    required this.controller,
    this.labelText = "",
    this.labelTextFlag = false,
    this.readOnly = false,
    this.borderRadius = AppValues.INPUT_FIELD_BORDER_RADIUS,
    this.labelStyleFontSize = AppValues.INPUT_FIELD_LABEL_STYLE_FONT_SIZE,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.INPUT_FIELD,
      child: labelTextFlag
          ? TextField(
              cursorColor: cursorColor,
              controller: controller,
              autofocus: autofocus,
              style: AppStyles.inputFieldTextStyle,
              //textAlignVertical: TextAlignVertical(y: 0.6),
              readOnly: readOnly,
              enableInteractiveSelection: !readOnly,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: colorBg,
                  hintStyle: TextStyle(color: hintStyleColor),
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                  labelText: labelText,
                  labelStyle: TextStyle(color: labelStyleColor, fontSize: labelStyleFontSize),
                  hoverColor: hoverColor,
                  focusColor: focusColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide:
                          BorderSide(color: borderColor, width: 1.5, style: BorderStyle.solid)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide:
                          BorderSide(color: borderColor, width: 1.5, style: BorderStyle.solid)),
                  hintText: placeholder),
            )
          : TextField(
              readOnly: readOnly,
              enableInteractiveSelection: !readOnly,
              cursorColor: cursorColor,
              controller: controller,
              autofocus: autofocus,
              style: AppStyles.inputFieldTextStyle,
              textAlignVertical: const TextAlignVertical(y: 0.6),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: colorBg, //Colors.blue.shade50,
                  hintStyle: TextStyle(color: hintStyleColor),
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide:
                          BorderSide(color: borderColor, width: 1.5, style: BorderStyle.solid)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide:
                          BorderSide(color: borderColor, width: 1.5, style: BorderStyle.solid)),
                  hintText: placeholder),
            ),
    );
  }
}
