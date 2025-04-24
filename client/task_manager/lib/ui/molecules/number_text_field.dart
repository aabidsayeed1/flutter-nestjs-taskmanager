import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_imports.dart';
import '../../core/constants/country_constants.dart';

// ignore: must_be_immutable
class NumberTextField extends StatefulWidget {
  final bool addCountryCode;
  final TextEditingController controller;
  final String labelText;
  final double dropDownIconSize;
  final double flagHeight;
  final double flagWidth;
  final double containerHeight;
  Map<String, dynamic> initialValue;
  final void Function(Map<String, dynamic>) dropDownFunction;
  final Color borderErrorColor;
  final double borderWidth;
  final Color errorTextColor;
  Color borderColor;
  final bool bEnable;
  final String? errorText;

  NumberTextField(
      {Key? key,
      this.addCountryCode = true,
      required this.controller,
      this.labelText = "Enter mobile number",
      this.dropDownIconSize = 15,
      this.flagHeight = 20,
      this.flagWidth = 30,
      this.containerHeight = 50,
      required this.initialValue,
      required this.dropDownFunction,
      this.borderErrorColor = Colors.red,
      this.borderWidth = 1.5,
      this.errorTextColor = Colors.red,
      this.bEnable = true,
      this.errorText,
      this.borderColor = Colors.grey})
      : super(
          key: key,
        );

  @override
  NumberTextFieldState createState() => NumberTextFieldState();
}

class NumberTextFieldState extends State<NumberTextField> {
  final StreamController<Map<String, dynamic>> _dropDownChangeStream =
      StreamController<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (Utils.phoneNumberValidate(widget.controller.text, widget.initialValue["max_length"])) {
        setState(() {
          widget.borderColor = Colors.grey;
        });
      } else {
        setState(() {
          widget.borderColor = widget.borderErrorColor;
        });
      }
    });
  }

  @override
  void dispose() {
    _dropDownChangeStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: _dropDownChangeStream.stream,
        initialData: widget.initialValue,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: widget.containerHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: _notContainsError(widget.errorText)
                              ? widget.borderColor
                              : widget.borderErrorColor,
                          width: widget.borderWidth),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                    ),
                    child: PopupMenuButton<Map<String, dynamic>>(
                      enabled: widget.bEnable,
                      initialValue: snapshot.data!,
                      itemBuilder: (context) {
                        return countries.map<PopupMenuItem<Map<String, dynamic>>>((value) {
                          return PopupMenuItem(
                            enabled: widget.bEnable,
                            value: value,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/flags/${value["code"]!.toLowerCase()}.png',
                                  height: widget.flagHeight,
                                  width: widget.flagWidth,
                                ),
                                Expanded(
                                    child: Text(
                                  value["name"],
                                  overflow: TextOverflow.ellipsis,
                                )),
                                Text(
                                  " +${value["dial_code"]}",
                                  style: AppStyles.numberFieldSubHeading,
                                ),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (value) {
                        _dropDownChangeStream.add(value);
                        widget.dropDownFunction(value);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Image.asset(
                                'assets/flags/${snapshot.data!["code"]!.toLowerCase()}.png',
                                height: widget.flagHeight,
                              ),
                            ),
                            Center(
                              child: Text(
                                " +${snapshot.data!["dial_code"]}",
                                style: AppStyles.numberFieldSubHeading,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                              size: widget.dropDownIconSize,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: widget.containerHeight,
                      child: Form(
                        child: TextFormField(
                          enabled: widget.bEnable,
                          controller: widget.controller,
                          onFieldSubmitted: (text) {
                            setState(() {
                              widget.borderColor = Colors.grey;
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            LengthLimitingTextInputFormatter(snapshot.data!["max_length"]),
                          ],
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                          style: AppStyles.numberFieldInputStyle,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _notContainsError(widget.errorText)
                                          ? widget.borderColor
                                          : widget.borderErrorColor,
                                      width: widget.borderWidth),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _notContainsError(widget.errorText)
                                          ? widget.borderColor
                                          : widget.borderErrorColor,
                                      width: widget.borderWidth),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4))),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _notContainsError(widget.errorText)
                                          ? widget.borderColor
                                          : widget.borderErrorColor,
                                      width: widget.borderWidth),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4))),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: widget.borderErrorColor, width: widget.borderWidth),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                              ),
                              // contentPadding: EdgeInsets.all(5),
                              labelText: widget.labelText,
                              labelStyle: TextStyle(
                                  color: _notContainsError(widget.errorText)
                                      ? AppColors.NUMBER_TEXT_FIELD_TEXT
                                      : widget.borderErrorColor,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!_notContainsError(widget.errorText))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(widget.errorText!,
                      style: TextStyle(color: widget.errorTextColor, fontSize: 13)),
                ),
            ],
          );
        });
  }

  bool _notContainsError(String? errorText) {
    return !(errorText != null && errorText.isNotEmpty);
  }
}
