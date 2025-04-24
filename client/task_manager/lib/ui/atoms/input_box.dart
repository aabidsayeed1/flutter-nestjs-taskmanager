import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final bool bTextArea;
  final InputState inputState;
  final String? strErrorMessage;
  final bool bAutoFocus;
  final String strPlaceHolder;
  final String strLabelText;
  final bool bIsLabel;
  final TextEditingController controller;
  final TextStyle? labelTextStyle;
  final Widget? inputIcon;
  final bool bIconLeft;
  final bool bIcon;
  final InputDecoration? inputDecoration;
  final double dBorderRadius;
  final Color? borderColor;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextStyle? placeHolderStyle;
  final TextStyle? errorTextStyle;
  const InputBox({
    Key? key,
    this.bTextArea = false,
    this.inputState = InputState.Default,
    this.strErrorMessage,
    this.bAutoFocus = false,
    required this.strPlaceHolder,
    required this.controller,
    this.strLabelText = "",
    this.bIsLabel = false,
    this.labelTextStyle,
    this.inputIcon,
    this.bIconLeft = false,
    this.bIcon = false,
    this.inputDecoration,
    this.dBorderRadius = AppValues.INPUT_BOX_BORDER_RADIUS,
    this.borderColor,
    this.maxLines = 4,
    this.textStyle,
    this.placeHolderStyle,
    this.errorTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.INPUT_BOX,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bIsLabel && strLabelText.isNotEmpty)
            Text(strLabelText, style: labelTextStyle ?? AppStyles.inputBoxLabelStyle),
          if (bIsLabel && strLabelText.isNotEmpty) Gap(8),
          TextField(
            controller: controller,
            autofocus: bAutoFocus,
            textAlignVertical: TextAlignVertical.center,
            readOnly: inputState == InputState.disabled ? true : false,
            keyboardType: bTextArea ? TextInputType.multiline : null,
            maxLines: bTextArea ? maxLines : 1,
            style:
                textStyle ??
                ((inputState == InputState.disabled)
                    ? AppStyles.inputBoxDisabledTextStyle
                    : AppStyles.inputBoxFocusedTextStyle),
            decoration:
                inputDecoration ??
                InputDecoration(
                  hintText: strPlaceHolder,
                  hintStyle: placeHolderStyle ?? AppStyles.inputBoxPlaceHolderStyle,
                  contentPadding:
                      inputState == InputState.error
                          ? const EdgeInsets.only(bottom: 0.0, top: 15.0)
                          : null,
                  prefix:
                      inputState == InputState.error
                          ? const Padding(padding: EdgeInsets.only(left: 15.0))
                          : null,
                  filled: inputState == InputState.disabled ? true : false,
                  fillColor:
                      inputState == InputState.disabled ? AppColors.INPUT_BOX_DISABLED_BG : null,
                  suffixIcon: (bIcon && !bIconLeft && !bTextArea) ? inputIcon : null,
                  prefixIcon: (bIcon && bIconLeft && !bTextArea) ? inputIcon : null,
                  errorText: (inputState == InputState.error) ? strErrorMessage : null,
                  errorStyle: errorTextStyle,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(dBorderRadius),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.INPUT_BOX_DISABLED_BORDER,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(dBorderRadius),
                    borderSide: BorderSide(
                      color:
                          borderColor ??
                          (inputState == InputState.disabled
                              ? AppColors.INPUT_BOX_DISABLED_BORDER
                              : AppColors.INPUT_BOX_FOCUSED_BORDER),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(dBorderRadius),
                    borderSide: const BorderSide(color: AppColors.INPUT_BOX_ERROR_BORDER),
                  ),
                  border: const OutlineInputBorder(),
                ),
          ),
        ],
      ),
    );
  }
}
