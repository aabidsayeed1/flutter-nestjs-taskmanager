import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../atoms/primary_button.dart';

class RowTwoButtons extends StatelessWidget {
  final String strButtonOne;
  final String strButtonTwo;
  final VoidCallback buttonActionOne;
  final VoidCallback buttonActionTwo;
  final Color textColorOne;
  final Color textColorTwo;
  final Color bgColorOne;
  final Color bgColorTwo;

  const RowTwoButtons({
    Key? key,
    required this.strButtonOne,
    required this.strButtonTwo,
    required this.buttonActionOne,
    required this.buttonActionTwo,
    this.textColorOne = AppColors.BLACK,
    this.textColorTwo = AppColors.BLACK,
    this.bgColorOne = AppColors.GREY,
    this.bgColorTwo = AppColors.PRIMARY_COLOR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ROW_TWO_BUTTONS,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              color: Colors.transparent,
              child: PrimaryButton(
                strButtonText: strButtonOne,
                textStyle: TextStyle(color: textColorOne, fontWeight: FontWeight.w600),
                bgColor: bgColorOne,
                buttonAction: buttonActionOne,
              ),
            ),
          ),
          CustomSpacers.width4,
          Expanded(
            child: Container(
              height: 48,
              color: Colors.transparent,
              child: PrimaryButton(
                strButtonText: strButtonTwo,
                bgColor: bgColorTwo,
                buttonAction: buttonActionTwo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
