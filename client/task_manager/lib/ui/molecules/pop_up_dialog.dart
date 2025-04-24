import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';
import '../molecules/row_two_buttons.dart';

class PopupDialog extends StatelessWidget {
  final String strTitle;
  final String strMessage;
  final String strButtonOne;
  final String strButtonTwo;
  final VoidCallback buttonActionOne;
  final VoidCallback buttonActionTwo;
  final Color dividerColor;
  final Color textColorOne;
  final Color textColorTwo;
  final Color bgColorOne;
  final Color bgColorTwo;
  final TextStyle titleStyle;
  final TextStyle messageStyle;

  const PopupDialog({
    Key? key,
    required this.strTitle,
    required this.strMessage,
    required this.strButtonOne,
    required this.strButtonTwo,
    required this.buttonActionOne,
    required this.buttonActionTwo,
    this.dividerColor = AppColors.POPUP_DIALOG_DIVIDER_COLOR,
    this.textColorOne = AppColors.POPUP_DIALOG_TEXT_COLOR,
    this.textColorTwo = AppColors.POPUP_DIALOG_TEXT_COLOR,
    this.bgColorOne = AppColors.POPUP_DIALOG_BG_ONE_COLOR,
    this.bgColorTwo = AppColors.POPUP_DIALOG_BG_TWO_COLOR,
    this.titleStyle = AppStyles.titleStyle,
    this.messageStyle = AppStyles.messageStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.POP_UP_DIALOG,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomSpacers.height8,
            Text(strTitle, style: titleStyle),
            CustomSpacers.height16,
            Divider(
              height: 1,
              color: dividerColor,
            ),
            CustomSpacers.height16,
            Text(strMessage, style: messageStyle),
            CustomSpacers.height24,
            RowTwoButtons(
              strButtonOne: strButtonOne,
              strButtonTwo: strButtonTwo,
              buttonActionOne: buttonActionOne,
              buttonActionTwo: buttonActionTwo,
              textColorOne: textColorOne,
              textColorTwo: textColorTwo,
              bgColorOne: bgColorOne,
              bgColorTwo: bgColorTwo,
            )
          ],
        ),
      ),
    );
  }
}
