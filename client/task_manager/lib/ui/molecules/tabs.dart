import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  final int length;
  final bool bVertical;
  final List<Widget> tabs;
  final List<Widget> tabBarView;
  final Color fillColor;
  final TextStyle? activeTextStyle;
  final TextStyle? inActiveTextStyle;
  final Color activeBorderColor;
  final Color inActiveBorderColor;
  final TabsHorizontalState tabsHorizontalState;
  final TabsVerticalState tabsVerticalState;
  final Function(int)? onClickTab;
  final int selectedTabIndex;
  final Color activeLabelColor;
  final Color inActiveLabelColor;
  final double dVerticalTabWidth;
  final Color tabLabelColorFilled;

  const Tabs({
    Key? key,
    required this.length,
    this.bVertical = false,
    required this.tabs,
    required this.tabBarView,
    this.fillColor = AppColors.TABS_FILL_COLOR,
    this.activeTextStyle,
    this.inActiveTextStyle,
    this.activeBorderColor = AppColors.TABS_ACTIVE_BORDER_COLOR,
    this.inActiveBorderColor = AppColors.TABS_IN_ACTIVE_BORDER_COLOR,
    this.tabsHorizontalState = TabsHorizontalState.Default,
    this.tabsVerticalState = TabsVerticalState.left,
    this.onClickTab,
    this.selectedTabIndex = 0,
    this.activeLabelColor = AppColors.TABS_ACTIVE_LABEL_COLOR,
    this.inActiveLabelColor = AppColors.TABS_IN_ACTIVE_LABEL_COLOR,
    this.dVerticalTabWidth = AppValues.VERTICAL_TAB_WIDTH,
    this.tabLabelColorFilled = AppColors.TABS_TEXT_COLOR_FILLED,
  }) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _selectedTabIndex;
  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.selectedTabIndex;

    if (widget.bVertical) {
      _selectTab(_selectedTabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.TABS,
      child: widget.bVertical ? _verticalTabView() : _horizontalTabView(),
    );
  }

  Widget _horizontalTabView() {
    return DefaultTabController(
      length: widget.length,
      initialIndex: _selectedTabIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            tabs:
                widget.tabs.map((tab) {
                  return Tab(child: tab);
                }).toList(),
            indicator:
                widget.tabsHorizontalState == TabsHorizontalState.filled
                    ? BoxDecoration(shape: BoxShape.rectangle, color: widget.fillColor)
                    : null,
            isScrollable: widget.tabsHorizontalState == TabsHorizontalState.Default ? true : false,
            labelStyle: widget.activeTextStyle ?? AppStyles.tabsActiveTextStyle,
            unselectedLabelStyle: widget.inActiveTextStyle ?? AppStyles.tabsInActiveTextStyle,
            labelColor:
                widget.tabsHorizontalState == TabsHorizontalState.filled
                    ? widget.tabLabelColorFilled
                    : widget.activeLabelColor,
            unselectedLabelColor: widget.inActiveLabelColor,
            indicatorColor:
                widget.tabsHorizontalState == TabsHorizontalState.filled
                    ? Colors.transparent
                    : widget.activeBorderColor,
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return Colors.transparent;
            }),
            onTap: (int val) {
              if (widget.onClickTab != null) {
                widget.onClickTab!(val);
              }
            },
          ),
          Expanded(child: TabBarView(children: widget.tabBarView)),
        ],
      ),
    );
  }

  Widget _verticalTabView() {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Material(
                child: SizedBox(
                  width: widget.dVerticalTabWidth,
                  child: ListView.builder(
                    itemCount: widget.tabs.length,
                    itemBuilder: (context, index) {
                      TextStyle tabStyle;
                      if (_selectedTabIndex == index) {
                        if (widget.activeTextStyle != null) {
                          tabStyle = widget.activeTextStyle!.copyWith(
                            color:
                                widget.tabsVerticalState == TabsVerticalState.filled
                                    ? widget.tabLabelColorFilled
                                    : widget.activeLabelColor,
                          );
                        } else {
                          tabStyle = AppStyles.tabsActiveTextStyle.copyWith(
                            color:
                                widget.tabsVerticalState == TabsVerticalState.filled
                                    ? widget.tabLabelColorFilled
                                    : widget.activeLabelColor,
                          );
                        }
                      } else {
                        if (widget.inActiveTextStyle != null) {
                          tabStyle = widget.inActiveTextStyle!.copyWith(
                            color: widget.inActiveLabelColor,
                          );
                        } else {
                          tabStyle = AppStyles.tabsInActiveTextStyle.copyWith(
                            color: widget.inActiveLabelColor,
                          );
                        }
                      }
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectTab(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 8.5, bottom: 8.5, left: 24, right: 4),
                          decoration: BoxDecoration(
                            color:
                                widget.tabsVerticalState == TabsVerticalState.filled
                                    ? (_selectedTabIndex == index ? widget.fillColor : null)
                                    : null,
                            border: Border(
                              right:
                                  widget.tabsVerticalState == TabsVerticalState.right
                                      ? _verticalBorderSide(index)
                                      : BorderSide.none,
                              left:
                                  widget.tabsVerticalState == TabsVerticalState.left
                                      ? _verticalBorderSide(index)
                                      : BorderSide.none,
                            ),
                          ),
                          child: DefaultTextStyle(style: tabStyle, child: widget.tabs[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(child: widget.tabBarView[_selectedTabIndex]),
            ],
          ),
        ),
      ],
    );
  }

  BorderSide _verticalBorderSide(int index) {
    return BorderSide(
      width: _selectedTabIndex == index ? 2.0 : 1.0,
      color: _selectedTabIndex == index ? widget.activeBorderColor : widget.inActiveBorderColor,
    );
  }

  void _selectTab(index) {
    _selectedTabIndex = index;
    if (widget.onClickTab != null) {
      widget.onClickTab!(_selectedTabIndex);
    }
  }
}
