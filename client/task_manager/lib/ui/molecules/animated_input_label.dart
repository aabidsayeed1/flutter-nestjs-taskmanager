import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class AnimatedInputLabel extends StatelessWidget {
  final InputState inputState;
  final String strLabelTitle;
  final TextEditingController controller;
  final TextStyle? textStyle;
  final bool bAutoFocus;
  final InputDecoration? inputDecoration;
  final String? strErrorMessage;
  final TextStyle? labelTextStyle;
  final TextStyle? hintLabelTextStyle;

  const AnimatedInputLabel({
    Key? key,
    this.inputState = InputState.Default,
    required this.strLabelTitle,
    required this.controller,
    this.textStyle,
    this.bAutoFocus = false,
    this.inputDecoration,
    this.strErrorMessage,
    this.labelTextStyle,
    this.hintLabelTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ANIMATED_INPUT_LABEL,
      child: TextField(
        controller: controller,
        autofocus: bAutoFocus,
        style:
            textStyle ??
            ((inputState == InputState.disabled)
                ? AppStyles.animatedInputLabelDisabledStyle
                : AppStyles.animatedInputLabelFocusedTextStyle),
        readOnly: inputState == InputState.disabled ? true : false,
        decoration:
            inputDecoration ??
            InputDecoration(
              labelText: strLabelTitle,
              labelStyle: labelTextStyle ?? AppStyles.animatedInputLabelStyle,
              errorText: (inputState == InputState.error) ? strErrorMessage : null,
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.INPUT_BOX_ERROR_BORDER),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      (inputState == InputState.error)
                          ? AppColors.INPUT_BOX_ERROR_BORDER
                          : AppColors.INPUT_BOX_DISABLED_BORDER,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      inputState == InputState.disabled
                          ? AppColors.INPUT_BOX_DISABLED_BORDER
                          : (inputState == InputState.error)
                          ? AppColors.INPUT_BOX_ERROR_BORDER
                          : AppColors.INPUT_BOX_FOCUSED_BORDER,
                ),
              ),
              disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.INPUT_BOX_DISABLED_BORDER),
              ),

              // Set contentPadding to increase the padding between hint and text
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
            ),
      ),
    );
  }
}
