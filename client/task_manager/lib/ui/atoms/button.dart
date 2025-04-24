import 'package:easy_debounce/easy_debounce.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Button extends StatelessWidget {
  final String strButtonText;
  final VoidCallback buttonAction;
  final double dCornerRadius;
  final Color borderColor;
  final bool bIcon;
  final bool bIconLeft;
  final String? buttonIconUrl;
  final Color? buttonIconColor;
  final EdgeInsets? padding;
  final int debounceDuration;
  final double? width;
  final double? height;
  final ButtonType type;
  final ButtonSize size;
  final ButtonState state;
  final bool bIconOnly;
  final TextStyle? textStyle;
  final Color? buttonBackgroundColor;
  final double? textWidth;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const Button({
    Key? key,
    required this.strButtonText,
    required this.buttonAction,
    this.dCornerRadius = AppValues.PRIMARY_BUTTON_CORNER_RADIUS,
    this.borderColor = AppColors.PRIMARY_BUTTON_BORDERCOLOR,
    this.bIconLeft = true,
    this.bIcon = false,
    this.buttonIconUrl,
    this.buttonIconColor,
    this.padding,
    this.debounceDuration = 500,
    this.width,
    this.height,
    this.type = ButtonType.primary,
    this.size = ButtonSize.normal,
    this.bIconOnly = false,
    this.state = ButtonState.Default,
    this.textStyle,
    this.buttonBackgroundColor,
    this.textWidth,
    this.textOverflow,
    this.maxLines,
  }) : super(key: key);

  factory Button.icon({
    String strButtonText = '',
    required VoidCallback buttonAction,
    required bool bIconLeft,
    Color borderColor = Colors.transparent,
    required String? iconUrl,
    required Color bgColor,
    TextStyle? textStyle,
    double dCornerRadius = AppValues.PRIMARY_BUTTON_CORNER_RADIUS,
  }) {
    return Button(
      strButtonText: strButtonText,
      buttonAction: buttonAction,
      buttonIconUrl: iconUrl,
      bIconLeft: bIconLeft,
      bIcon: true,
      dCornerRadius: dCornerRadius,
      borderColor: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.BUTTON,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color:
                AppColors.button[type.toString().split('.').last]![state
                    .toString()
                    .split('.')
                    .last],
            borderRadius: BorderRadius.circular(dCornerRadius),
            border:
                (type == (ButtonType.borderless) || (state == ButtonState.disabled))
                    ? null
                    : Border.all(color: borderColor, width: 1),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dCornerRadius),
            ),
            onTap:
                (state == ButtonState.disabled)
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
              padding:
                  padding ??
                  EdgeInsets.symmetric(
                    horizontal: AppValues.buttonHorizontalPadding(
                      size: size.toString().split('.').last,
                      isOnlyIcon: bIconOnly,
                    ),
                    vertical: AppValues.buttonVerticalPadding(
                      size: size.toString().split('.').last,
                      isOnlyIcon: bIconOnly,
                    ),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (bIcon == true && bIconLeft == true) _buttonIcon(),
                  if (bIcon == true && bIconLeft == true && !bIconOnly) ...[Gap(8)],
                  if (strButtonText.isNotEmpty && !bIconOnly)
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: textWidth ?? double.infinity),
                      child: Text(
                        strButtonText,
                        style:
                            textStyle ??
                            AppStyles.buttonTextStyle(
                              style: type.toString().split('.').last,
                              size: size.toString().split('.').last,
                              state: state.toString().split('.').last,
                            ),
                        maxLines: maxLines,
                        overflow: textOverflow,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (bIcon == true && bIconLeft == false && !bIconOnly) Gap(8),
                  if (bIcon == true && bIconLeft == false) _buttonIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonIcon() {
    return Container(
      height: AppValues.iconHeight(size: size.toString().split('.').last),
      width: AppValues.iconWidth(size: size.toString().split('.').last),
      color: Colors.transparent,
      child: SvgPicture.asset(
        buttonIconUrl ?? AppImages.PLUS_ICON,
        colorFilter: HelperUI.getSVGCOlor(
          buttonIconColor ??
              AppColors.buttonIconColorFun(
                type.toString().split('.').last,
                state.toString().split('.').last,
              ),
        ),
        // color: buttonIconColor ??
        //     AppColors.buttonIconColorFun(type.toString().split('.').last,
        //         state.toString().split('.').last),
      ),
    );
  }
}
