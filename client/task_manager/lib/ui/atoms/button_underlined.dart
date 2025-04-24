import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class ButtonUnderlined extends StatelessWidget {
  final String strButtonText;
  final TextStyle styleButtonText;
  final void Function() buttonAction;
  final double dBorderWidth;
  final Color colorBorder;

  const ButtonUnderlined(
      {Key? key,
      required this.strButtonText,
      this.buttonAction = _defaultFunction,
      this.styleButtonText = AppStyles.buttonUnderlinedText,
      this.dBorderWidth = 0,
      this.colorBorder = Colors.transparent})
      : super(key: key);

  static _defaultFunction() {
    // Does nothing
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.BUTTON_UNDERLINED,
      child: Center(
          child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: dBorderWidth, color: colorBorder),
        ),
        onPressed: buttonAction,
        child: Text(strButtonText,
            textAlign: TextAlign.center,
            style: styleButtonText.copyWith(
                color: AppColors.BUTTON_UNDERLINED_TEXT,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.2,
                height: 1.2,
                decoration: TextDecoration.underline)),
      )),
    );
  }
}
