import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CustomCheckbox extends StatefulWidget {
  final bool bError;
  final bool bDisable;
  bool bLabelPositionLeft;
  bool bSelected;
  final String strCheckboxText;
  final Function(bool) selectedValue;
  final Color cTextColor;
  final double dRadius;
  final double dBorderWidth;
  final Widget? checkboxIcon;
  final bool bShowIcon;
  final CheckboxType checkboxType;
  final String strErrorText;
  final TextStyle? errorTextStyle;
  final Color defaultColor;
  final Color errorColor;
  final Color activeColor;
  final Color disabledColor;
  final Color selectedDisabledColor;

  CustomCheckbox({
    Key? key,
    required this.strCheckboxText,
    this.bDisable = false,
    this.bLabelPositionLeft = true,
    this.bError = false,
    this.bSelected = false,
    required this.selectedValue,
    this.dRadius = AppValues.CHECKBOX_CORNER_RADIUS,
    this.dBorderWidth = AppValues.CHECKBOX_BORDER_WIDTH,
    this.bShowIcon = false,
    this.checkboxIcon,
    this.cTextColor = AppColors.BASICBLACK,
    this.checkboxType = CheckboxType.Custom,
    this.strErrorText = "",
    this.errorTextStyle,
    this.defaultColor = AppColors.CHECKBOX_DEFAULT_COLOR,
    this.errorColor = AppColors.CHECKBOX_ERROR_BASE,
    this.activeColor = AppColors.CHECKBOX_SELECTED_COLOR,
    this.disabledColor = AppColors.CHECKBOX_DISABLE_COLOR,
    this.selectedDisabledColor = AppColors.CHECKBOX_SELECTED_DISABLED_COLOR,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCustomCheckboxtate();
}

class _CustomCustomCheckboxtate extends State<CustomCheckbox> {
  bool? bSelected;

  @override
  void initState() {
    super.initState();
    bSelected = widget.bSelected;
    if (widget.bShowIcon == true) {
      setState(() {
        widget.bLabelPositionLeft = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CHECKBOX,
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
                      color: AppColors.CHECKBOX_BG_COLOR,
                      border: Border.all(
                        color:
                            widget.bError
                                ? widget.errorColor
                                : bSelected!
                                ? widget.activeColor
                                : Colors.transparent,
                        width: bSelected! ? widget.dBorderWidth : 0,
                      ),
                      borderRadius: BorderRadius.circular(AppValues.CHECKBOX_OUTER_RADIUS),
                    )
                    : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.bShowIcon && widget.checkboxIcon != null) widget.checkboxIcon!,
                if (widget.bShowIcon &&
                    !widget.bLabelPositionLeft &&
                    widget.checkboxType == CheckboxType.Custom)
                  Gap(4),
                if (widget.bShowIcon && widget.bLabelPositionLeft)
                  widget.bLabelPositionLeft
                      ? Gap(4)
                      : widget.checkboxType == CheckboxType.Custom
                      ? Gap(8)
                      : Gap(4),
                if (widget.bLabelPositionLeft)
                  _labelText(paddingRight: widget.checkboxType == CheckboxType.Custom ? 8 : 4),
                if (widget.bLabelPositionLeft) const Spacer(),
                checkboxWidget(),
                if (!widget.bLabelPositionLeft)
                  _labelText(paddingLeft: widget.checkboxType == CheckboxType.Custom ? 8 : 4),
              ],
            ),
          ),
          if (widget.bError)
            Padding(
              padding: EdgeInsets.only(
                top: !widget.bShowIcon && widget.checkboxType == CheckboxType.Default ? 0 : 4,
                left:
                    widget.bLabelPositionLeft
                        ? widget.checkboxType == CheckboxType.Custom
                            ? 0
                            : 0
                        : widget.bShowIcon
                        ? 0
                        : widget.checkboxType == CheckboxType.Custom
                        ? 0
                        : 6,
              ),
              child: Text(
                widget.strErrorText,
                style: widget.errorTextStyle ?? AppStyles.checkboxErrorTextStyle,
              ),
            ),
        ],
      ),
    );
  }

  Widget checkboxWidget() {
    if (widget.checkboxType == CheckboxType.Custom) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                if (!widget.bDisable) {
                  bSelected = !bSelected!;
                  widget.selectedValue(!bSelected!);
                }
              });
            },
            child: Container(
              width: AppValues.CHECKBOX_SIZE,
              height: AppValues.CHECKBOX_SIZE,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      widget.bError
                          ? widget.errorColor
                          : bSelected!
                          ? widget.bDisable
                              ? widget.disabledColor
                              : widget.activeColor
                          : AppColors.CHECKBOX_DISABLED_BORDER_COLOR,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(widget.dRadius),
              ),
              child: Container(
                width: AppValues.CHECKBOX_SIZE,
                height: AppValues.CHECKBOX_SIZE,
                decoration: BoxDecoration(
                  color:
                      bSelected!
                          ? widget.bDisable
                              ? widget.selectedDisabledColor
                              : widget.activeColor
                          : widget.bDisable
                          ? widget.selectedDisabledColor
                          : widget.defaultColor,
                  borderRadius: BorderRadius.circular(widget.dRadius - 1),
                ),
                child: Center(
                  child:
                      bSelected!
                          ? SvgPicture.asset(
                            AppImages.CHECKBOX_TICK_ICON,
                            colorFilter: HelperUI.getSVGCOlor(
                              widget.bDisable ? widget.disabledColor : AppColors.WHITE,
                            ),
                            // color: widget.bDisable
                            //     ? widget.disabledColor
                            //     : AppColors.WHITE,
                            height: 11,
                            width: 13,
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (widget.bDisable && widget.bError == false) {
      return Checkbox(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        value: widget.bSelected,
        side: BorderSide(width: AppValues.CHECKBOX_WIDTH, color: widget.disabledColor),
        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (widget.bDisable && widget.bError == false) {
            return widget.disabledColor;
          }
          if (widget.bError == true) {
            return widget.errorColor;
          }
          return widget.activeColor;
        }),
        onChanged: (value) {
          setState(() {
            if (widget.bDisable == false) {
              widget.bSelected = value!;
              widget.selectedValue(value);
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.dRadius)),
      );
    }
    if (widget.bDisable == false && widget.bError == false) {
      return Checkbox(
        value: widget.bSelected,
        activeColor: widget.activeColor,
        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (widget.bDisable && widget.bError == false) {
            return widget.disabledColor;
          }
          if (widget.bError == true) {
            return widget.errorColor;
          }
          if (widget.bSelected == true) {
            return widget.activeColor;
          }
          return widget.disabledColor;
        }),
        onChanged: (value) {
          setState(() {
            if (widget.bDisable == false) {
              widget.bSelected = value!;
              widget.selectedValue(value);
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.dRadius)),
      );
    }
    if (widget.bError == true) {
      return Checkbox(
        value: widget.bSelected,
        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          return widget.errorColor;
        }),
        onChanged: (value) {
          setState(() {
            if (widget.bDisable == false) {
              widget.bSelected = value!;
              widget.selectedValue(value);
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.dRadius)),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _labelText({double paddingLeft = 0, double paddingRight = 0}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
        child: Text(widget.strCheckboxText, style: AppStyles.checkboxTextStyle),
      ),
    );
  }
}
