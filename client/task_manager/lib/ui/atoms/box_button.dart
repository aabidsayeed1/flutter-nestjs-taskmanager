import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class BoxButton extends StatelessWidget {
  final bool bAccessor;
  final Color colorBase;
  final String strButtonText;
  final double dCornerRadius;
  final Color borderColor;
  final TextAlign buttonTextAlignment;
  final void Function() buttonAction;
  final MainAxisAlignment mainAxisAlignment;

  const BoxButton(
      {Key? key,
      this.bAccessor = false,
      this.colorBase = Colors.transparent,
      this.borderColor = Colors.transparent,
      required this.strButtonText,
      this.mainAxisAlignment = MainAxisAlignment.spaceAround,
      this.buttonAction = _defaultFunction,
      this.buttonTextAlignment = TextAlign.center,
      this.dCornerRadius = AppValues.BOX_BUTTON_CORNER_RADIUS})
      : super(key: key);

  static _defaultFunction() {
    // Does nothing
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.BOX_BUTTON,
      child: InkWell(
          onTap: buttonAction,
          child: Container(
              decoration: BoxDecoration(
                color: colorBase,
                borderRadius: BorderRadius.circular(dCornerRadius),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: bAccessor == false
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(strButtonText,
                          textAlign: buttonTextAlignment,
                          style: AppStyles.styleBoxButtonText),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(strButtonText,
                                textAlign: buttonTextAlignment,
                                style: AppStyles.styleBoxButtonText),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          )
                        ],
                      ),
                    ))),
    );
  }
}
