import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';

import '../automation_constants.dart';

class InputNumber extends StatefulWidget {
  final TextEditingController controller;
  final int step;
  final int? min;
  final int? max;
  final bool bAutoFocus;
  final InputNumberSizes inputNumberSize;
  final Widget? upArrowIcon;
  final Widget? downArrowIcon;
  final int? value;
  final FocusNode? focusNode;
  final bool bDisable;
  final double dBorderRadius;
  final Color? borderColor;
  final TextStyle? textStyle;
  final Color? fillColor;
  final double? size;
  final Color cursorColor;

  const InputNumber({
    Key? key,
    required this.controller,
    this.step = 1,
    this.min,
    this.max,
    this.bAutoFocus = false,
    this.inputNumberSize = InputNumberSizes.small,
    this.upArrowIcon,
    this.downArrowIcon,
    this.value,
    this.focusNode,
    this.bDisable = false,
    this.dBorderRadius = AppValues.INPUT_NUMBER_BORDER_RADIUS,
    this.borderColor,
    this.textStyle,
    this.fillColor,
    this.size,
    this.cursorColor = AppColors.INPUT_NUMBER_CURSOR_COLOR,
  }) : super(key: key);

  @override
  State<InputNumber> createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  bool _showIcons = false;
  bool _isFocused = false;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    widget.controller.text = (widget.value != null) ? (widget.value).toString() : "0";
    focusNode = widget.focusNode ?? FocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          _showIcons = true;
        });
      } else {
        setState(() {
          _showIcons = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.INPUT_NUMBER,
      child: TextField(
        controller: widget.controller,
        autofocus: widget.bAutoFocus,
        keyboardType: TextInputType.none,
        focusNode: focusNode,
        readOnly: true,
        showCursor: widget.bDisable ? false : true,
        cursorColor: widget.cursorColor,
        style:
            widget.textStyle ??
            AppStyles.inputNumberTextStyle(widget.bDisable, _isFocused, widget.inputNumberSize),
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        decoration: InputDecoration(
          suffixIcon: (_showIcons && widget.bDisable == false) ? _arrowIcons() : null,
          fillColor:
              widget.fillColor ??
              (widget.bDisable ? AppColors.INPUT_NUMBER_DISABLED_FILL_COLOR : null),
          filled: (widget.fillColor != null || widget.bDisable) ? true : false,
          isDense: true,
          suffixIconConstraints: const BoxConstraints(
            maxWidth: AppValues.INPUT_NUMBER_SUFFIX_ICON_MAX_WIDTH,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.size ?? InputNumberMapSizes(widget.inputNumberSize),
            horizontal: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.dBorderRadius),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.INPUT_NUMBER_DISABLED_BORDER_COLOR,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.dBorderRadius),
            borderSide: BorderSide(
              color:
                  widget.borderColor ??
                  (widget.bDisable
                      ? AppColors.INPUT_NUMBER_DISABLED_BORDER_COLOR
                      : AppColors.INPUT_NUMBER_FOCUSED_BORDER_COLOR),
            ),
          ),
        ),
      ),
    );
  }

  Widget _arrowIcons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1, top: 1, right: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: AppColors.INPUT_NUMBER_ICON_BORDER_COLOR),
                left: BorderSide(width: 1.0, color: AppColors.INPUT_NUMBER_ICON_BORDER_COLOR),
              ),
            ),
            child: InkWell(
              onTap: () {
                int currentValue = int.parse(widget.controller.text);
                if (widget.max == null || (currentValue < widget.max!)) {
                  currentValue = currentValue + widget.step;
                }
                widget.controller.value = widget.controller.value.copyWith(
                  text: currentValue.toString(),
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: currentValue.toString().length),
                  ),
                );
              },
              child:
                  widget.upArrowIcon ??
                  const Icon(Icons.arrow_drop_up, color: AppColors.INPUT_NUMBER_ICONS_COLOR),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: AppColors.INPUT_NUMBER_ICON_BORDER_COLOR),
                left: BorderSide(width: 1.0, color: AppColors.INPUT_NUMBER_ICON_BORDER_COLOR),
              ),
            ),
            child: InkWell(
              onTap: () {
                int currentValue = int.parse(widget.controller.text);
                if (widget.min == null || (currentValue > widget.min!)) {
                  currentValue = currentValue - widget.step;
                }
                widget.controller.value = widget.controller.value.copyWith(
                  text: currentValue.toString(),
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: currentValue.toString().length),
                  ),
                );
              },
              child:
                  widget.downArrowIcon ??
                  const Icon(Icons.arrow_drop_down, color: AppColors.INPUT_NUMBER_ICONS_COLOR),
            ),
          ),
        ],
      ),
    );
  }
}
