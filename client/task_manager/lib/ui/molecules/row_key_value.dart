import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class RowKeyValue extends StatelessWidget {
  final String strKey;
  final String? strSubKey;
  final String strValue;
  final double
      dWidth; // Passing this to decide it we need space between key and value OR it has to show up next to each other
  final TextStyle styleKey;
  final TextStyle? styleSubKey;
  final TextStyle styleValue;
  final double? width;
  final bool isCancel;
  final bool useMaxSpace;
  final double borderRadius;
  final EdgeInsetsGeometry dPadding;
  final Alignment textAlignForValue;

  const RowKeyValue({
    Key? key,
    required this.strKey,
    required this.strValue,
    required this.dWidth,
    this.strSubKey,
    this.styleSubKey = AppStyles.rowKeyValueStyleSubKey,
    this.width,
    this.isCancel = false,
    this.useMaxSpace = false,
    this.borderRadius = AppValues.ROW_KEY_VALUE_BORDER_RADIUS,
    this.styleKey = AppStyles.rowKeyValueStyleKey,
    this.styleValue = AppStyles.rowKeyValueStyleValue,
    this.dPadding = const EdgeInsets.only(left: 20, right: 20),
    this.textAlignForValue = Alignment.topRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ROW_KEY_VALUE,
      child: Container(
        padding: dPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isCancel
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strKey,
                        style: styleKey,
                      ),
                      Text(
                        strSubKey ?? '',
                        style: styleSubKey,
                      ),
                    ],
                  )
                : Text(
                    strKey,
                    style: styleKey,
                  ),
            if (useMaxSpace) const Spacer() else SizedBox(width: width),
            Text(
              strValue,
              style: styleValue,
            ),
          ],
        ),
      ),
    );
  }
}
