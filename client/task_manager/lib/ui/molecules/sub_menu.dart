import 'dart:async';

import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class SubMenu extends StatefulWidget {
  const SubMenu({
    required this.items,
    required this.onPressed,
    this.autoCollapse = true,
    this.highlightExpanded = true,
    this.showIndicatorIcon = true,
    this.isIndicatorIconLeading = false,
    this.isSubMenuWidgetLeading = false,
    this.showSubMenuWidget = true,
    this.backgroundColor = AppColors.SUBMENU_BG,
    this.highlightColor = AppColors.SUBMENU_HIGHLIGHT,
    this.menuTitleTextStyle,
    this.subMenuTitleTextStyle,
    this.subTitleTextStyle,
    this.expandedMenuTitleTextStyle,
    Key? key,
  }) : super(key: key);

  final List<MenuItem> items;
  final bool highlightExpanded;
  final bool autoCollapse;
  final bool showIndicatorIcon;
  final bool isIndicatorIconLeading;

  ///only shows when sub menu widget is passed in SubMenuItem
  final bool showSubMenuWidget;
  final bool isSubMenuWidgetLeading;
  final TextStyle? menuTitleTextStyle;
  final TextStyle? expandedMenuTitleTextStyle;
  final TextStyle? subTitleTextStyle;
  final TextStyle? subMenuTitleTextStyle;
  final Color backgroundColor;
  final Color highlightColor;
  final Function(String id) onPressed;

  @override
  SubMenuState createState() => SubMenuState();
}

class SubMenuState extends State<SubMenu> {
  final StreamController<int> _expandedIndexStreamController = StreamController();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.SUBMENU,
      child: Container(
        color: widget.backgroundColor,
        child: StreamBuilder<int>(
          stream: _expandedIndexStreamController.stream,
          initialData: -1,
          builder: (context, snapshot) {
            int expandedIndex = snapshot.data!;
            return Align(
              child: Column(
                children: <Widget>[
                  for (int menuIndex = 0; menuIndex < widget.items.length; menuIndex++)
                    _getTile(widget.items[menuIndex], menuIndex, expandedIndex),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _getTile(MenuItem item, int menuIndex, int expandedIndex) {
    bool isExpanded = expandedIndex == menuIndex;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.highlightExpanded && isExpanded)
          Container(
            height:
                item.subTitle != null
                    ? AppValues.MENU_HIGHLIGHT_SUBTITLE_HEIGHT
                    : AppValues.MENU_HIGHLIGHT_HEIGHT,
            width: AppValues.MENU_HIGHLIGHT_WIDTH,
            color: AppColors.SUBMENU_HIGHLIGHT,
          ),
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: widget.autoCollapse ? Key("$menuIndex $expandedIndex") : null,
              initiallyExpanded: expandedIndex == menuIndex,
              trailing:
                  widget.showIndicatorIcon && !widget.isIndicatorIconLeading
                      ? Image.asset(
                        isExpanded ? AppImages.SUB_MENU_EXPANDED_ICON : AppImages.SUB_MENU_ICON,
                        height: 8,
                      )
                      : const SizedBox(),
              leading:
                  widget.showIndicatorIcon && widget.isIndicatorIconLeading
                      ? Image.asset(
                        isExpanded ? AppImages.SUB_MENU_EXPANDED_ICON : AppImages.SUB_MENU_ICON,
                        height: 8,
                      )
                      : null,
              onExpansionChanged: (expanded) {
                if (expanded) {
                  _expandedIndexStreamController.add(menuIndex);
                } else {
                  _expandedIndexStreamController.add(-1);
                }
              },
              subtitle:
                  item.subTitle != null
                      ? Text(item.subTitle!, style: widget.subTitleTextStyle ?? AppStyles.subTitle)
                      : null,
              title: Text(
                item.title,
                style:
                    expandedIndex == menuIndex
                        ? widget.expandedMenuTitleTextStyle ?? AppStyles.expandedMenuTitle
                        : widget.menuTitleTextStyle ?? AppStyles.menuTitle,
              ),
              children: [
                for (int subMenuIndex = 0; subMenuIndex < item.subMenuItems.length; subMenuIndex++)
                  Padding(
                    padding: EdgeInsets.only(
                      left:
                          widget.isIndicatorIconLeading
                              ? AppValues.SUBMENU_PADDING_W_LEADING_ICON
                              : AppValues.SUBMENU_PADDING,
                    ),
                    child: ListTile(
                      horizontalTitleGap: 0,
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: 0.0, right: 2.0),
                      leading:
                          (widget.showSubMenuWidget &&
                                  widget.isSubMenuWidgetLeading &&
                                  item.subMenuItems[subMenuIndex].widget != null)
                              ? item.subMenuItems[subMenuIndex].widget!
                              : null,
                      trailing:
                          (widget.showSubMenuWidget &&
                                  !widget.isSubMenuWidgetLeading &&
                                  item.subMenuItems[subMenuIndex].widget != null)
                              ? item.subMenuItems[subMenuIndex].widget!
                              : null,
                      title: Text(
                        item.subMenuItems[subMenuIndex].title,
                        style: widget.subMenuTitleTextStyle ?? AppStyles.subMenuTitle,
                      ),
                      onTap: () {
                        widget.onPressed(item.subMenuItems[subMenuIndex].id);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MenuItem {
  final String title;
  final String? subTitle;
  final List<SubMenuItem> subMenuItems;
  MenuItem({required this.title, this.subTitle, required this.subMenuItems});
}

class SubMenuItem {
  final String title;
  final String id;
  final Widget? widget;
  SubMenuItem({required this.title, required this.id, this.widget});
}
