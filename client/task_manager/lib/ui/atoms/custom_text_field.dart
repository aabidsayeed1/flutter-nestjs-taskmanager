import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    this.focusNode,
    this.prefix,
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
    this.isRequired = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.disabled = false,
    this.fillColor = AppColors.CUSTOM_TEXT_FIELD_FILL,
    this.leftPadding = 19.0,
    this.textCapitalization = TextCapitalization.none,
    Key? key,
  }) : super(key: key);

  final String? errorText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Widget? prefix;
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
  final Color fillColor;
  final double leftPadding;
  final TextCapitalization textCapitalization;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final StreamController<bool> _focusChangeStream = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CUSTOM_TEXT_FIELD,
      child: SizedBox(
        height: widget.errorText != null && widget.errorText!.isNotEmpty
            ? AppValues.CUSTOM_TEXT_FIELD_HEIGHT_W_ERROR
            : AppValues.CUSTOM_TEXT_FIELD_HEIGHT,
        child: Column(
          children: [
            StreamBuilder<bool>(
                stream: _focusChangeStream.stream,
                initialData: false,
                builder: (context, snapshot) {
                  bool focused = snapshot.data!;
                  return Container(
                    height: AppValues.CUSTOM_TEXT_FIELD_HEIGHT,
                    decoration: BoxDecoration(
                        color: focused ? null : widget.fillColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: widget.errorText != null
                                ? AppColors.CUSTOM_TEXT_FIELD_ERROR
                                : focused
                                    ? AppColors.CUSTOM_TEXT_FIELD_FOCUSED
                                    : widget.fillColor)),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: widget.prefix != null ? 0.0 : widget.leftPadding),
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          _focusChangeStream.add(hasFocus);
                        },
                        child: TextField(
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          controller: widget.controller,
                          enabled: !widget.disabled,
                          cursorColor: AppColors.CUSTOM_TEXT_FIELD_FOCUSED,
                          autofocus: widget.autoFocus,
                          focusNode: widget.focusNode,
                          inputFormatters: widget.inputFormatters,
                          keyboardType: widget.keyboardType,
                          textCapitalization: widget.textCapitalization,
                          maxLength: widget.maxLength,
                          obscureText: widget.obscureText,
                          obscuringCharacter: widget.obscuringCharacter,
                          style: AppStyles.textFieldInputStyle,
                          decoration: InputDecoration(
                              counterText: "",
                              isDense: true,
                              hintText: widget.hint,
                              // labelText: widget.label,
                              label: widget.label != null
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
                                                  ))
                                          ]),
                                    )
                                  : null,
                              labelStyle: AppStyles.customTextFieldLabel,
                              contentPadding: EdgeInsets.only(
                                  top: (widget.label != null &&
                                          (widget.prefix != null || widget.suffix != null))
                                      ? 6
                                      : widget.label != null
                                          ? (focused
                                              ? 6.0
                                              : widget.controller.text.isNotEmpty
                                                  ? 6.0
                                                  : 13.0)
                                          : 13.0),
                              border: InputBorder.none,
                              prefixIcon: widget.prefix,
                              suffixIcon: widget.suffix),
                        ),
                      ),
                    ),
                  );
                }),
            if (widget.errorText != null && widget.errorText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 2.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.errorText!,
                    style: AppStyles.textFieldErrorStyle,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
