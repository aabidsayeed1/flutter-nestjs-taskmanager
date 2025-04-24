import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class CustomExpandableTextField extends StatefulWidget {
  const CustomExpandableTextField(
      {required this.controller,
      this.focusNode,
      this.inputFormatters,
      this.hint,
      this.label,
      this.isRequired = false,
      this.disabled = false,
      this.errorText,
      Key? key})
      : super(key: key);

  final TextEditingController controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final String? hint;
  final String? label;
  final bool disabled;
  final bool isRequired;
  final String? errorText;

  @override
  _CustomExpandableTextFieldState createState() =>
      _CustomExpandableTextFieldState();
}

class _CustomExpandableTextFieldState extends State<CustomExpandableTextField> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CUSTOM_EXPANDABLE_TEXT_FIELD,
      child: Container(
          constraints: const BoxConstraints(
            minHeight: 72.0,
          ),
          child: Column(
            children: [
              Scrollbar(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: SizedBox(
                        height: 72.0,
                        child: TextField(
                          enabled: !widget.disabled,
                          controller: widget.controller,
                          focusNode: widget.focusNode,
                          cursorColor: AppColors.CUSTOM_TEXT_FIELD_FOCUSED,
                          cursorHeight: 7,
                          style: AppStyles.textFieldInputStyle,
                          inputFormatters: widget.inputFormatters,
                          decoration: InputDecoration(
                              labelStyle: AppStyles.customTextFieldLabel,
                              hintText: widget.hint,
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
                                                    color: AppColors
                                                        .CUSTOM_TEXT_FIELD_ERROR,
                                                  ))
                                          ]),
                                    )
                                  : null,
                              hintStyle: AppStyles.customTextFieldLabel,
                              filled: true,
                              // contentPadding:
                              //     const EdgeInsets.only(left: 19.0, top: 16.0),
                              focusColor: AppColors.CUSTOM_TEXT_FIELD_FOCUSED,
                              fillColor: AppColors.CUSTOM_TEXT_FIELD_FILL,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.errorText != null
                                        ? AppColors.CUSTOM_TEXT_FIELD_ERROR
                                        : AppColors.CUSTOM_TEXT_FIELD_FILL,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.errorText != null
                                        ? AppColors.CUSTOM_TEXT_FIELD_ERROR
                                        : AppColors.CUSTOM_TEXT_FIELD_FILL,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.errorText != null
                                        ? AppColors.CUSTOM_TEXT_FIELD_ERROR
                                        : AppColors.CUSTOM_TEXT_FIELD_FOCUSED,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.errorText != null
                                        ? AppColors.CUSTOM_TEXT_FIELD_ERROR
                                        : AppColors.CUSTOM_TEXT_FIELD_FILL,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          maxLines: 500,
                          keyboardType: TextInputType.multiline,
                        ),
                      ))),
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
          )),
    );
  }
}
