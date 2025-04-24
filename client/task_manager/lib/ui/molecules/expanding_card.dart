import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';

import '../automation_constants.dart';

class ExpandingCard extends StatelessWidget {
  final Color colorBase;
  final String strTitle;
  final TextStyle styleTitle;
  final String strSubTitle;
  final TextStyle styleSubleTitle;
  final List<Widget> listOfWidgets;
  final double dBorderRadiusBase;
  final double dBorderWidth;
  final double dTitleSubTitleGap;
  final Color colorBorder;
  final Color colorIcon;
  final Color dividerColor;
  final bool showBorder;
  final Alignment expandedAlignment;
  final CrossAxisAlignment parentAlignment;

  const ExpandingCard({
    Key? key,
    this.strTitle = '',
    this.styleTitle = AppStyles.expandingCardTitleStyle,
    required this.strSubTitle,
    this.styleSubleTitle = AppStyles.expandingCardSubtitleStyle,
    this.dividerColor = AppColors.EXPANDING_CARD_DIVIDER_COLOR,
    this.colorBase = AppColors.EXPANDING_CARD_DIVIDER_COLOR,
    this.colorBorder = AppColors.EXPANDING_CARD_BORDER,
    this.dBorderRadiusBase = AppValues.EXPANDING_CARD_BORDER_RADIUS_BASE,
    this.dBorderWidth = AppValues.EXPANDING_CARD_BORDER_WIDTH,
    this.dTitleSubTitleGap = AppValues.EXPANDING_CARD_TITLE_SUBTITLE_GAP,
    this.colorIcon = AppColors.EXPANDING_CARD_ICON,
    required this.listOfWidgets,
    this.showBorder = false,
    this.expandedAlignment = Alignment.centerLeft,
    this.parentAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.EXPANDING_CARD,
      child: Container(
        decoration:
            showBorder
                ? BoxDecoration(
                  border: Border.all(color: colorBorder, width: dBorderWidth),
                  borderRadius: BorderRadius.circular(dBorderRadiusBase),
                  color: colorBase,
                )
                : null,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: dividerColor),
          child: ExpansionTile(
            collapsedIconColor: colorIcon,
            iconColor: colorIcon,
            title: Column(
              crossAxisAlignment: parentAlignment,
              children: <Widget>[
                CustomSpacers.height8,
                Text(
                  strTitle,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: styleTitle,
                ),
                SizedBox(height: dTitleSubTitleGap),
                strSubTitle != ""
                    ? Text(
                      strSubTitle,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: styleSubleTitle,
                    )
                    : Container(),
                CustomSpacers.height8,
              ],
            ),
            children: listOfWidgets,
            childrenPadding: const EdgeInsets.only(left: 15, right: 15),
            expandedAlignment: expandedAlignment,
          ),
        ),
      ),
    );
  }
}
