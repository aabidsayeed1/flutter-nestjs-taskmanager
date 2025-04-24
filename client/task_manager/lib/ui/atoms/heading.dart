import 'package:flutter/material.dart';

import 'package:task_manager/app_imports.dart';

import '../automation_constants.dart';

class Heading extends StatelessWidget {
  final HeadingVariants headingVariants;
  final String strHeaderText;
  final TextStyle? textStyle;
  const Heading({
    Key? key,
    this.headingVariants = HeadingVariants.h6,
    required this.strHeaderText,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.HEADING,
      child: Text(
        strHeaderText,
        style: textStyle ?? AppStyles.headingStyle[headingVariants.toString().split('.').last],
      ),
    );
  }
}
