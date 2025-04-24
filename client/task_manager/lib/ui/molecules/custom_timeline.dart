import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class CustomTimeline extends StatelessWidget {
  final TimeLineTypes timeLineType;
  final String strDate;
  final String strItem;
  final String strDescription;
  final Widget? icon;
  final TextStyle? dateTextStyle;
  final TextStyle? itemTextStyle;
  final TextStyle? descriptionTextStyle;
  final Color iconColor;
  final Color borderColor;
  final Color color;
  final bool bBorder;
  final double? height;
  final double? width;
  final double borderHeight;
  final double borderWidth;

  const CustomTimeline({
    Key? key,
    this.timeLineType = TimeLineTypes.dot,
    this.strDate = "",
    this.strItem = "",
    this.strDescription = "",
    this.icon,
    this.dateTextStyle,
    this.itemTextStyle,
    this.descriptionTextStyle,
    this.iconColor = AppColors.TIMELINE_ICON_COLOR,
    this.borderColor = AppColors.TIMELINE_BORDER_COLOR,
    this.color = AppColors.TIMELINE_COLOR,
    this.bBorder = true,
    this.height = AppValues.TIMELINE_HEIGHT,
    this.width = AppValues.TIMELINE_WIDTH,
    this.borderHeight = AppValues.TIMELINE_BORDER_HEIGHT,
    this.borderWidth = AppValues.TIMELINE_BORDER_WIDTH,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.TIMELINE,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_iconColumn(), CustomSpacers.width16, _dataColumn()],
        ),
      ),
    );
  }

  Widget _iconColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          child: Container(
            height: timeLineType == TimeLineTypes.dot ? height : null,
            width: timeLineType == TimeLineTypes.dot ? width : null,
            padding: EdgeInsets.all(timeLineType == TimeLineTypes.icon ? 8 : 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: color),
            child:
                timeLineType == TimeLineTypes.icon
                    ? icon ?? Image.asset("assets/images/timeline_tick.png", height: 12, width: 12)
                    : null,
          ),
        ),
        if (bBorder) CustomSpacers.height8,
        if (bBorder) _border(),
      ],
    );
  }

  Widget _border() {
    return Container(
      color: borderColor,
      width: borderWidth,
      constraints: BoxConstraints(minHeight: borderHeight, maxHeight: borderHeight),
    );
  }

  Widget _dataColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (strDate.isNotEmpty)
            Text(strDate, style: dateTextStyle ?? AppStyles.timelineDateStyle),
          if (strDate.isNotEmpty) CustomSpacers.height6,
          if (strItem.isNotEmpty)
            Text(strItem, style: itemTextStyle ?? AppStyles.timelineItemStyle),
          if (strItem.isNotEmpty) CustomSpacers.height6,
          if (strDescription.isNotEmpty)
            Text(strDescription, style: descriptionTextStyle ?? AppStyles.timelineDescriptionStyle),
          CustomSpacers.height6,
        ],
      ),
    );
  }
}
