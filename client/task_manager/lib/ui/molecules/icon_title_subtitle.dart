import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';

import '../automation_constants.dart';

class IconTitleSubTitle extends StatelessWidget {
  final String strIconName;
  final Color colorIcon;
  final String strTitle;
  final String strSubTitle;
  final Color colorBase;
  final double dBorderRadiusBase;
  final Color colorBorder;
  final double dBorderWidth;
  final TextStyle styleTitle;
  final TextStyle styleSubTitle;
  final double dTitleSubTitleGap;
  final double dPadding;
  final double dImagePadding;
  final double width;
  final double height;
  final bool hasIcon;
  final CrossAxisAlignment crossAxisAlignment;
  final bool needsConstraints;
  final bool showBorder;
  final double dIconScale;

  const IconTitleSubTitle({
    Key? key,
    required this.strIconName,
    required this.strTitle,
    required this.strSubTitle,
    this.colorBase = AppColors.ICON_TITLE_SUBTITLE_BASE,
    this.dBorderRadiusBase = AppValues.ICON_TITLE_SUBTITLE_BORDER_RADIUS,
    this.colorBorder = AppColors.ICON_TITLE_SUBTITLE_BORDER,
    this.dBorderWidth = AppValues.ICON_TITLE_SUBTITLE_BORDER_WIDTH,
    this.colorIcon = AppColors.ICON_TITLE_SUBTITLE_ICON_COLOR,
    this.styleTitle = AppStyles.styleTitle,
    this.styleSubTitle = AppStyles.styleSubtitle,
    this.dTitleSubTitleGap = AppValues.ICON_TITLE_SUBTITLE_GAP,
    this.dPadding = AppValues.ICON_TITLE_SUBTITLE_PADDING,
    this.dImagePadding = AppValues.ICON_TITLE_SUBTITlE_IMAGE_PADDING,
    this.hasIcon = true,
    this.width = AppValues.ICON_TITLE_SUBTITLE_WIDTH,
    this.height = AppValues.ICON_TITLE_SUBTITLE_HEIGHT,
    this.needsConstraints = false,
    this.showBorder = false,
    this.dIconScale = AppValues.ICON_TITLE_SUBTITLE_ICON_SCALE,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ICON_TITLE_SUB_TITLE,
      child: Container(
        height: height,
        width: width,
        decoration:
            showBorder
                ? BoxDecoration(
                  border: Border.all(color: colorBorder, width: dBorderWidth),
                  borderRadius: BorderRadius.circular(dBorderRadiusBase),
                  color: colorBase,
                )
                : null,
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            if (strIconName.toString().isNotEmpty)
              const SizedBox(height: 16)
            else
              const SizedBox.shrink(),
            if (strIconName.toString().isNotEmpty && hasIcon)
              Padding(
                padding: EdgeInsets.only(top: dImagePadding, bottom: dImagePadding),
                child: Image.asset(strIconName, color: colorIcon, scale: dIconScale),
              ),
            if (strIconName.toString().isNotEmpty && hasIcon) const SizedBox(width: 8),
            Padding(
              padding: EdgeInsets.zero,
              // padding: !hasIcon ? EdgeInsets.zero : EdgeInsets.all(dPadding),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                children: <Widget>[
                  Text(
                    strTitle,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: styleTitle,
                  ),
                  SizedBox(height: dTitleSubTitleGap),
                  if (needsConstraints)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 118),
                      child: Text(
                        strSubTitle,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: styleSubTitle,
                      ),
                    )
                  else
                    Text(
                      strSubTitle,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: styleSubTitle,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
