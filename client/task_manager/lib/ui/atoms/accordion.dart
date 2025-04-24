import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final List<AccordionData> accordion;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final TextStyle? subHeadingTextStyle;
  final Widget? expandeIcon;
  final Widget? collapaseIcon;
  final Color? dividerColor;
  final double? dividerHeight;
  final void Function(int) clickAction;

  const Accordion({
    Key? key,
    required this.accordion,
    this.titleTextStyle,
    this.contentTextStyle,
    this.subHeadingTextStyle,
    required this.expandeIcon,
    this.collapaseIcon,
    this.dividerColor = AppColors.BLACK,
    this.dividerHeight = AppValues.DIVIDER_HEIGHT,
    required this.clickAction,
  }) : super(key: key);

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  void _toggleExpanded(int index) {
    setState(() {
      widget.accordion[index].isExpanded = !widget.accordion[index].isExpanded!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ACCORDION,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.ACCORDION_BOARDER_COLOR),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView.builder(
              itemCount: widget.accordion.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                AccordionData accodionData = widget.accordion[index];
                return GestureDetector(
                  onTap: () {
                    _toggleExpanded(index);
                    widget.clickAction(index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      index != 0
                          ? const Divider(color: AppColors.ACCORDION_BOARDER_COLOR)
                          : Container(),
                      ListTile(
                        title: Container(
                          padding: const EdgeInsets.only(
                            top: AppValues.TITLE_VERTICAL_PADDING,
                            bottom: AppValues.TITLE_VERTICAL_PADDING,
                          ),
                          child: Text(
                            accodionData.strTitle!,
                            style: widget.titleTextStyle ?? AppStyles.accordionTitleText,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.only(
                            top: AppValues.TITLE_VERTICAL_PADDING,
                            bottom: AppValues.TITLE_VERTICAL_PADDING,
                          ),
                          child: widget.expandeIcon,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: widget.accordion[index].isExpanded! ? null : 0,
                        child: Column(
                          children: [
                            Divider(thickness: widget.dividerHeight, color: widget.dividerColor),
                            if (accodionData.strSubHeading!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.only(
                                  left: AppValues.HORIZONTAL_PADDING,
                                  right: AppValues.HORIZONTAL_PADDING,
                                  top: AppValues.SUBHEADING_VERTICAL_PADDING,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        accodionData.strSubHeading ?? "",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            widget.subHeadingTextStyle ??
                                            AppStyles.accordionSubHeading,
                                      ),
                                    ),
                                    widget.collapaseIcon ??
                                        Container(
                                          height: AppValues.IMAGE_SIZE_UP_HEIGHT,
                                          width: AppValues.IMAGE_SIZE_UP_WIDTH,
                                          alignment: Alignment.center,
                                          child: Image.asset(AppImages.ACCORDION_UP_ARROW),
                                        ),
                                  ],
                                ),
                              )
                            else
                              Container(),
                            Container(
                              padding: const EdgeInsets.only(
                                left: AppValues.HORIZONTAL_PADDING,
                                right: AppValues.HORIZONTAL_PADDING,
                                top: AppValues.CONTENT_VERTICAL_PADDING,
                                bottom: AppValues.CONTENT_VERTICAL_PADDING,
                              ),
                              child:
                                  (accodionData.body != null)
                                      ? accodionData.body
                                      : Text(
                                        accodionData.strContent!,
                                        style:
                                            widget.contentTextStyle ??
                                            AppStyles.accordionContentTextStyle(),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AccordionData {
  final String? strTitle;
  final String? strContent;
  final Widget? body;
  final String? strSubHeading;
  bool? isExpanded;

  AccordionData({
    required this.strTitle,
    this.strSubHeading = "",
    this.strContent,
    this.isExpanded = false,
    this.body,
  });
}
