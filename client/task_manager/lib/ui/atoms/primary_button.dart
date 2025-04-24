import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class PrimaryButton extends StatelessWidget {
  final bool isBusy;
  final String strButtonText;
  final VoidCallback buttonAction;
  final double dCornerRadius;
  final Color borderColor;
  final Color bgColor;
  final Color fgColor;
  final Color textColor;
  final TextAlign buttonTextAlignment;
  final bool bIcon;
  final bool bIconLeft; // By default left will be true
  final bool bIsGradient; // By default, false
  final Widget? buttonIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final TextStyle? textStyle;
  final bool isGradient;
  final bool bFillColor;
  final bool disabled;
  final EdgeInsets? padding;
  final LinearGradient? gradient;
  final Color disabledColor;
  final int debounceDuration;
  final Color loderColor;
  final double fontSize;
  final double width;
  final bool bEndAlinged;

  const PrimaryButton({
    Key? key,
    required this.strButtonText,
    required this.buttonAction,
    this.dCornerRadius = AppValues.PRIMARY_BUTTON_CORNER_RADIUS,
    this.borderColor = AppColors.PRIMARY_BUTTON_BORDERCOLOR,
    this.bgColor = AppColors.PRIMARY_BUTTON_BG,
    this.fgColor = AppColors.PRIMARY_BUTTON_FG,
    this.textColor = Colors.white,
    this.textStyle = AppStyles.stylePrimaryButton,
    this.fontSize = 16,
    this.buttonTextAlignment = TextAlign.center,
    this.bIconLeft = true,
    this.bIcon = false,
    this.buttonIcon,
    this.mainAxisAlignment,
    this.bIsGradient = false,
    this.isGradient = false,
    this.bFillColor = false,
    this.disabled = false,
    this.bEndAlinged = false,
    this.padding,
    this.gradient,
    this.disabledColor = AppColors.PRIMARY_BUTTON_DISABLEDCOLOR,
    this.debounceDuration = 0,
    this.isBusy = false,
    this.width = double.infinity,
    this.loderColor = AppColors.PRIMARY_BUTTON_LOADERDCOLOR,
  }) : super(key: key);

  factory PrimaryButton.icon({
    String strButtonText = '',
    required VoidCallback buttonAction,
    required bool bIconLeft,
    Color borderColor = Colors.transparent,
    required Widget? icon,
    required Color bgColor,
    TextStyle? textStyle,
    double dCornerRadius = AppValues.PRIMARY_BUTTON_CORNER_RADIUS,
  }) {
    return PrimaryButton(
      strButtonText: strButtonText,
      buttonAction: buttonAction,
      buttonIcon: icon,
      bIconLeft: bIconLeft,
      bIcon: true,
      textStyle: textStyle,
      bgColor: bgColor,
      dCornerRadius: dCornerRadius,
      borderColor: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.PRIMARY_BUTTON,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: width,
          decoration:
              (isGradient)
                  ? BoxDecoration(
                    gradient: gradient ?? LinearGradient(colors: [bgColor, fgColor]),
                    borderRadius: BorderRadius.circular(dCornerRadius),
                    border: Border.all(color: borderColor, width: 1),
                  )
                  : (bFillColor)
                  ? BoxDecoration(
                    borderRadius: BorderRadius.circular(dCornerRadius),
                    border: Border.all(color: borderColor, width: 1),
                  )
                  : BoxDecoration(
                    color: disabled ? bgColor.withOpacity(0.5) : bgColor,
                    borderRadius: BorderRadius.circular(dCornerRadius),
                    border: Border.all(color: borderColor, width: 1),
                  ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dCornerRadius),
            ),
            onTap:
                disabled || isBusy
                    ? null
                    : () {
                      EasyDebounce.debounce(
                        AppStrings.STRING_DEBOUNCE_PRIMARY_BUTTON,
                        Duration(milliseconds: debounceDuration),
                        () {
                          buttonAction();
                        },
                      );
                    },
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (bIcon == true && bIconLeft == true)
                    Container(color: Colors.transparent, child: buttonIcon!),
                  if (bIcon == true && bIconLeft == true && !bEndAlinged) ...[Gap(8)],
                  if (bIcon == true && bIconLeft == true && bEndAlinged) ...[const Spacer()],
                  if (isBusy)
                    SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: bFillColor ? loderColor : AppColors.WHITE,
                      ),
                    ),
                  if (bIcon == true && bIconLeft == false && bEndAlinged) ...[
                    const SizedBox(width: 80),
                  ],
                  if (strButtonText.isNotEmpty && !isBusy)
                    Text(
                      strButtonText,
                      textAlign: buttonTextAlignment,
                      style: bFillColor ? AppStyles.styleSecondaryButton : textStyle,
                    ),
                  if (bIcon == true && bIconLeft == true && bEndAlinged) ...[
                    const SizedBox(width: 80),
                  ],
                  if (bIcon == true && bIconLeft == false && bEndAlinged == false) Gap(8),
                  if (bIcon == true && bIconLeft == false && bEndAlinged == true) const Spacer(),
                  if (bIcon == true && bIconLeft == false) buttonIcon!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
