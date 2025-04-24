import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  final String strValue;
  final String strGroupValue;
  final void Function(String) selectedValue;
  final bool? bIsSelected;
  final bool bIsDisabled;
  final bool bIsError;
  final String strErrorText;
  final TextStyle? errorTextStyle;
  final String strLabelText;
  final TextStyle? labelActiveTextStyle;
  final TextStyle? labelUnActiveTextStyle;
  final Widget? icon;
  final bool bShowIcon;
  final bool bLabelPositionLeft;
  final Color defaultColor;
  final Color backgroundColor;
  final Color activeColor;
  final Color disabledColor;
  final Color selectedDisabledColor;
  final Color errorColor;
  final double dRadius;
  final double dBorderWidth;
  final RadioButtonType radioButtonType;

  const RadioButton({
    Key? key,
    required this.strValue,
    required this.strGroupValue,
    required this.selectedValue,
    this.bIsSelected,
    this.bIsDisabled = false,
    this.bIsError = false,
    this.strErrorText = "",
    this.errorTextStyle,
    required this.strLabelText,
    this.labelActiveTextStyle,
    this.labelUnActiveTextStyle,
    this.icon,
    this.bShowIcon = false,
    this.bLabelPositionLeft = false,
    this.defaultColor = AppColors.RADIO_BUTTON_DEFAULT_COLOR,
    this.backgroundColor = AppColors.RADIO_BUTTON_BG_COLOR,
    this.activeColor = AppColors.RADIO_BUTTON_SELECTED_COLOUR,
    this.disabledColor = AppColors.RADIO_BUTTON_DISABLED_COLOUR,
    this.selectedDisabledColor = AppColors.RADIO_BUTTON_SELECTED_DISABLED_COLOR,
    this.errorColor = AppColors.RADIO_BUTTON_ERROR_COLOUR,
    this.dRadius = AppValues.RADIO_BUTTON_CORNER_RADIUS,
    this.dBorderWidth = AppValues.RADIO_BUTTON_BORDER_WIDTH,
    this.radioButtonType = RadioButtonType.Custom,
  }) : super(key: key);

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  late String selectedGroupValue;

  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    selectedGroupValue = widget.strGroupValue;
    isSelected = widget.bIsSelected ?? false;
    if (widget.bIsSelected != null && widget.bIsSelected == true) {
      selectedGroupValue = widget.strValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.RADIO_BUTTON,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: (widget.bShowIcon) ? const EdgeInsets.all(16.0) : const EdgeInsets.all(0),
            decoration:
                (widget.bShowIcon)
                    ? BoxDecoration(
                      color: widget.backgroundColor,
                      border: Border.all(
                        color:
                            widget.bIsError
                                ? widget.errorColor
                                : isSelected
                                ? widget.activeColor
                                : Colors.transparent,
                        width: isSelected ? widget.dBorderWidth : 0,
                      ),
                      borderRadius: BorderRadius.circular(AppValues.RADIO_BUTTON_OUTER_RADIUS),
                    )
                    : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.bShowIcon && widget.icon != null) widget.icon!,
                if (widget.bShowIcon &&
                    !widget.bLabelPositionLeft &&
                    widget.radioButtonType == RadioButtonType.Custom)
                  Gap(4),
                if (widget.bShowIcon && widget.bLabelPositionLeft)
                  widget.bLabelPositionLeft
                      ? Gap(4)
                      : widget.radioButtonType == RadioButtonType.Custom
                      ? Gap(8)
                      : Gap(4),
                if (widget.bLabelPositionLeft)
                  _labelText(
                    paddingRight: widget.radioButtonType == RadioButtonType.Custom ? 8 : 4,
                  ),
                if (widget.bLabelPositionLeft) const Spacer(),
                _radioButton(),
                if (!widget.bLabelPositionLeft)
                  _labelText(paddingLeft: widget.radioButtonType == RadioButtonType.Custom ? 8 : 4),
              ],
            ),
          ),
          if (widget.bIsError)
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left:
                    widget.bLabelPositionLeft
                        ? widget.radioButtonType == RadioButtonType.Custom
                            ? 0
                            : 0
                        : widget.bShowIcon
                        ? 0
                        : widget.radioButtonType == RadioButtonType.Custom
                        ? 0
                        : 3,
              ),
              child: Text(
                widget.strErrorText,
                textAlign: TextAlign.start,
                style: widget.errorTextStyle ?? AppStyles.radioButtonErrorTextStyle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _radioButton() {
    if (widget.radioButtonType == RadioButtonType.Custom) {
      return GestureDetector(
        onTap: () {
          if (!widget.bIsDisabled) {
            setState(() {
              isSelected = !isSelected;
              selectedGroupValue = widget.strValue;
              widget.selectedValue(widget.strValue);
            });
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: AppValues.RADIO_BUTTON_SIZE,
              height: AppValues.RADIO_BUTTON_SIZE,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      widget.bIsError
                          ? widget.errorColor
                          : isSelected
                          ? widget.bIsDisabled
                              ? widget.disabledColor
                              : widget.activeColor
                          : widget.disabledColor,
                  width:
                      isSelected
                          ? AppValues.RADIO_BUTTON_SELECTED_BORDER_WIDTH
                          : AppValues.RADIO_BUTTON_BORDER_WIDTH,
                ),
                borderRadius: BorderRadius.circular(AppValues.RADIO_BUTTON_SIZE * 3),
              ),
              child: Container(
                width: AppValues.RADIO_BUTTON_SIZE,
                height: AppValues.RADIO_BUTTON_SIZE,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? widget.bIsDisabled
                              ? widget.selectedDisabledColor
                              : widget.backgroundColor
                          : widget.bIsDisabled
                          ? widget.selectedDisabledColor
                          : widget.backgroundColor,
                  borderRadius: BorderRadius.circular(AppValues.RADIO_BUTTON_SIZE * 3),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Radio(
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      value: widget.strValue,
      groupValue: selectedGroupValue,
      splashRadius: 1,
      activeColor:
          widget.bIsDisabled
              ? widget.disabledColor
              : widget.bIsError
              ? widget.errorColor
              : widget.activeColor,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (widget.bIsError) {
          return widget.errorColor;
        } else if (widget.bIsDisabled) {
          return widget.disabledColor;
        } else if (widget.strValue == selectedGroupValue) {
          return widget.activeColor;
        }
        return widget.defaultColor;
      }),
      onChanged: (value) {
        if (widget.bIsDisabled == false) {
          setState(() {
            selectedGroupValue = widget.strValue;
          });
          widget.selectedValue(value.toString());
        }
      },
    );
  }

  Widget _labelText({double paddingLeft = 0, double paddingRight = 0}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
        child: Text(
          widget.strLabelText,
          textAlign: TextAlign.start,
          style:
              (selectedGroupValue == widget.strValue
                  ? (widget.labelActiveTextStyle ?? AppStyles.radioButtonActiveTextStyle)
                  : (widget.labelUnActiveTextStyle ?? AppStyles.radioButtonUnActiveTextStyle)),
        ),
      ),
    );
  }
}
