import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    this.focusNode,
    this.prefix,
    this.prefixText,
    this.suffix,
    this.maxLength,
    this.inputFormatters,
    this.keyboardType,
    this.hint,
    this.label,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.autoFocus = false,
    this.showError = true,
    this.isRequired = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.disabled = false,
    this.fillColor,
    this.leftPadding = 19.0,
    this.textCapitalization = TextCapitalization.none,
    this.hintStyle,
    this.onTap,
    this.labelStyle,
    this.textStyle,
    this.focusColor,
    this.radius,
    this.borderColor,
    this.bReadOnly = false,
    this.textInputAction,
    Key? key,
  }) : super(key: key);

  final String? errorText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Widget? prefix;
  final String? prefixText;
  final Widget? suffix;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? hint;
  final String? label;
  final bool autoFocus;
  final bool isRequired;
  final bool obscureText;
  final String obscuringCharacter;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool disabled;
  final bool showError;
  final Color? fillColor;
  final double leftPadding;
  final TextCapitalization textCapitalization;
  final TextStyle? hintStyle;
  final VoidCallback? onTap;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Color? focusColor;
  final double? radius;
  final Color? borderColor;
  final bool bReadOnly;
  final TextInputAction? textInputAction;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final StreamController<bool> _focusChangeStream = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CUSTOM_TEXT_FIELD,
      explicitChildNodes: true,
      child: Theme(
        data: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: AppColors.PRIMARY_ACTIVE,
          ),
        ),
        child: SizedBox(
          height:
              widget.errorText != null && widget.showError && widget.errorText!.isNotEmpty
                  ? AppValues.CUSTOM_TEXT_FIELD_HEIGHT_W_ERROR
                  : AppValues.CUSTOM_TEXT_FIELD_HEIGHT.h,
          child: Column(
            children: [
              StreamBuilder<bool>(
                stream: _focusChangeStream.stream,
                initialData: false,
                builder: (context, snapshot) {
                  bool focused = snapshot.data!;
                  return Container(
                    height: AppValues.CUSTOM_TEXT_FIELD_HEIGHT.h,
                    decoration: BoxDecoration(
                      color: widget.fillColor,
                      borderRadius: BorderRadius.circular(widget.radius ?? 8.r),
                      border: Border.all(
                        color:
                            widget.errorText != null
                                ? AppColors.semanticTextFeildError
                                : focused
                                ? widget.focusColor ?? AppColors.neutral300
                                : widget.borderColor ?? AppColors.neutral700,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: widget.prefix != null ? 0.0 : widget.leftPadding,
                      ),
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          _focusChangeStream.add(hasFocus);
                        },
                        child: TextField(
                          readOnly: widget.bReadOnly,
                          textInputAction: widget.textInputAction,
                          onTap: widget.onTap,
                          keyboardAppearance: Brightness.dark,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          controller: widget.controller,
                          enabled: !widget.disabled,
                          cursorColor: AppColors.basicWhite,
                          autofocus: widget.autoFocus,
                          focusNode: widget.focusNode,
                          inputFormatters: widget.inputFormatters,
                          keyboardType: widget.keyboardType,
                          textCapitalization: widget.textCapitalization,
                          maxLength: widget.maxLength,
                          obscureText: widget.obscureText,
                          obscuringCharacter: widget.obscuringCharacter,
                          cursorHeight: 24.h,
                          style: widget.textStyle ?? AppStyles.bodyTextBaseFontNormalNeutral300,
                          decoration: InputDecoration(
                            prefixText: widget.prefixText,
                            counterText: "",
                            isDense: true,
                            hintText: widget.hint,
                            // labelText: widget.label,
                            label:
                                widget.label != null
                                    ? RichText(
                                      text: TextSpan(
                                        text: widget.label,
                                        style: AppStyles.customTextFieldLabel,
                                        children: [
                                          if (widget.isRequired)
                                            const TextSpan(
                                              text: ' *',
                                              style: TextStyle(
                                                color: AppColors.CUSTOM_TEXT_FIELD_REQUIRED,
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                    : null,
                            hintStyle: widget.hintStyle ?? AppStyles.bodyTextBaseFontNormal,
                            labelStyle: widget.labelStyle ?? AppStyles.bodyTextBaseFontNormal,
                            contentPadding: EdgeInsets.only(
                              top:
                                  (widget.label != null &&
                                          (widget.prefix != null || widget.suffix != null))
                                      ? 6.h
                                      : widget.label != null
                                      ? (focused
                                          ? 6.h
                                          : widget.controller.text.isNotEmpty
                                          ? 6.h
                                          : 10.h)
                                      : 10.h,
                            ),
                            border: InputBorder.none,
                            prefixIcon: widget.prefix,
                            suffixIcon: widget.suffix,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (widget.errorText != null && widget.errorText!.isNotEmpty && widget.showError)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 2.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.errorText!,
                      style: AppStyles.captionTextXsFontNormalSemanticTextFeildError,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
