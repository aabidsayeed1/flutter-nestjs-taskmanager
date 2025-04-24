import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

import '../../app_imports.dart';

class RowIconTextAccessor extends StatelessWidget {
  final String strIconName;
  final double? iconScale;
  final String strText;
  final bool bAccessor;
  final TextStyle style;
  final Color colorBase;
  final String? strSubTitle;

  const RowIconTextAccessor({
    Key? key,
    required this.strIconName,
    required this.strText,
    this.iconScale = AppValues.ROW_ICON_TEXT_ACCESSOR_ICON_SCALE,
    this.bAccessor = false,
    this.style = AppStyles.rowIconTextAccessortextStyle,
    this.colorBase = AppColors.ROW_ICON_TEXT_ACCESSOR_COLOR_BASE,
    this.strSubTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ROW_ICON_TEXT_ACCESSOR,
      child: Container(
        color: colorBase,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (strIconName.isNotEmpty) Image.asset(strIconName, scale: iconScale),
            if (strIconName.isNotEmpty) CustomSpacers.width12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSpacers.height4,
                Text(strText, style: style),
                if (strSubTitle != null)
                  Text(
                    strSubTitle!,
                    style: style.copyWith(color: AppColors.ROW_ICON_TEXT_ACCESSOR_SUBTEXT_COLOR),
                  ),
              ],
            ),
            if (bAccessor == true) const Spacer(),
            if (bAccessor == true) const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
