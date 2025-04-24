import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class BreadCrumb extends StatefulWidget {
  final List<BreadCrumbItem> breadCrumbItems;
  final Widget? separator;
  final Widget? backArrowIcon;
  final bool bBackArrow;
  final Function()? backArrowClickAction;
  final TextStyle? activeTextStyle;
  final TextStyle? inActiveTextStyle;
  final String strSeparator;
  final double dIconSize;
  final TextStyle? separatorTextStyle;
  final double dPadding;
  final int? selectedIndex;

  const BreadCrumb({
    Key? key,
    required this.breadCrumbItems,
    this.separator,
    this.bBackArrow = false,
    this.backArrowClickAction,
    this.activeTextStyle,
    this.inActiveTextStyle,
    this.strSeparator = AppValues.BREAD_CRUMB_SEPARATOR,
    this.backArrowIcon,
    this.dIconSize = AppValues.BREAD_CRUMB_ICON_SIZE,
    this.separatorTextStyle,
    this.dPadding = AppValues.BREAD_CRUMB_PADDING,
    this.selectedIndex,
  }) : super(key: key);
  @override
  State<BreadCrumb> createState() => _BreadCrumbState();
}

class _BreadCrumbState extends State<BreadCrumb> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex ?? (widget.breadCrumbItems.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.BREADCRUMB,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double totalWidth = 0;
          List<Widget> breadCrumbItemsList = List.generate(widget.breadCrumbItems.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: widget.dPadding),
              child: GestureDetector(
                onTap: () {
                  widget.breadCrumbItems[index].onTap();
                },
                child: Text(
                  widget.breadCrumbItems[index].name,
                  style:
                      selectedIndex == index
                          ? (widget.activeTextStyle ?? AppStyles.breadCrumbActiveTextStyle)
                          : (widget.inActiveTextStyle ?? AppStyles.breadCrumbInActiveTextStyle),
                ),
              ),
            );
          });

          int firstIndex = 0;
          int lastIndex = widget.breadCrumbItems.length - 1;
          List<Widget> newBreadCrumbItemsList = [];
          int tFirstIndex = 0;

          while (firstIndex <= lastIndex) {
            final firstPainter = TextPainter(
              text: TextSpan(
                text: widget.breadCrumbItems[firstIndex].name,
                style:
                    firstIndex == selectedIndex
                        ? (widget.activeTextStyle ?? AppStyles.breadCrumbActiveTextStyle)
                        : (widget.inActiveTextStyle ?? AppStyles.breadCrumbInActiveTextStyle),
              ),
              textDirection: TextDirection.ltr,
            );
            firstPainter.layout(maxWidth: double.infinity);

            final lastPainter = TextPainter(
              text: TextSpan(
                text: widget.breadCrumbItems[lastIndex].name,
                style:
                    lastIndex == selectedIndex
                        ? (widget.activeTextStyle ?? AppStyles.breadCrumbActiveTextStyle)
                        : (widget.inActiveTextStyle ?? AppStyles.breadCrumbInActiveTextStyle),
              ),
              textDirection: TextDirection.ltr,
            );
            lastPainter.layout(maxWidth: double.infinity);

            if (firstIndex == lastIndex &&
                (totalWidth + firstPainter.width) < (constraints.maxWidth)) {
              newBreadCrumbItemsList.insert(tFirstIndex, breadCrumbItemsList[firstIndex]);
              break;
            }

            if ((totalWidth + firstPainter.width) < (constraints.maxWidth * 0.95)) {
              totalWidth += firstPainter.width;
              newBreadCrumbItemsList.insert(tFirstIndex, breadCrumbItemsList[firstIndex]);
              firstIndex += 1;
              tFirstIndex++;
            }
            if ((totalWidth + lastPainter.width) < (constraints.maxWidth * 0.95)) {
              totalWidth += lastPainter.width;
              newBreadCrumbItemsList.insert(tFirstIndex, breadCrumbItemsList[lastIndex]);
              lastIndex -= 1;
            }
            if ((totalWidth + firstPainter.width) > (constraints.maxWidth * 0.95) &&
                (totalWidth + lastPainter.width) > (constraints.maxWidth * 0.95)) {
              newBreadCrumbItemsList.insert(
                tFirstIndex,
                Text(
                  "... ",
                  style: widget.inActiveTextStyle ?? AppStyles.breadCrumbInActiveTextStyle,
                ),
              );
              break;
            }
          }

          List<Widget> finalBreadCrumbItemsList = [];

          for (int i = 0; i < newBreadCrumbItemsList.length; i++) {
            finalBreadCrumbItemsList.add(newBreadCrumbItemsList[i]);
            if (i != (newBreadCrumbItemsList.length - 1)) {
              finalBreadCrumbItemsList.add(
                Container(
                  padding: EdgeInsets.only(right: widget.dPadding),
                  child:
                      widget.separator ??
                      Text(
                        widget.strSeparator,
                        style: widget.separatorTextStyle ?? AppStyles.breadCrumbSeparatorStyle,
                      ),
                ),
              );
            }
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.bBackArrow
                    ? Padding(
                      padding: EdgeInsets.only(right: widget.dPadding),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.backArrowClickAction != null) {
                            widget.backArrowClickAction!();
                          }
                        },
                        child:
                            widget.backArrowIcon ??
                            Icon(
                              Icons.arrow_back,
                              color: AppColors.BREADCRUMB_INACTIVE_COLOR,
                              size: widget.dIconSize,
                            ),
                      ),
                    )
                    : Container(),
                ...finalBreadCrumbItemsList,
              ],
            ),
          );
        },
      ),
    );
  }
}

class BreadCrumbItem {
  String name;
  Function onTap;

  BreadCrumbItem({required this.name, required this.onTap});
}
