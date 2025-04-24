import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

// ignore: must_be_immutable
class CustomRoundedTabbar extends StatelessWidget {
  CustomRoundedTabbar({
    super.key,
    required this.tabs,
    this.selectedColor = AppColors.SELECTED_TAB_CUSTOM_ROUNDED_TAB_BAR,
    this.selectedTextColor = AppColors.SELECTED_TEXT_CUSTOM_ROUNDED_TAB_BAR,
    this.unselectedColor = AppColors.UNSELECTED_TAB_CUSTOM_ROUNDED_TAB_BAR,
    this.unselectedTextColor = AppColors.UNSELECTED_TEXT_CUSTOM_ROUNDED_TAB_BAR,
    this.onTap,
    this.tabIndex = 0,
    this.borderRadius = AppValues.CUSTOM_ROUNDED_TAB_BAR_BORDER_RADIUS,
  });
  final List<Tab> tabs;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double borderRadius;
  final void Function()? onTap;
  int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CUSTOM_ROUNDED_TAB_BAR,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 40,
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabs.map(
            (e) {
              if (tabIndex < 0) tabIndex = 0;
              bool selected = e == tabs[tabIndex];
              return Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? selectedColor : unselectedColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    child: Text(
                      e.text ?? '',
                      style: TextStyle(
                        color: selected ? selectedTextColor : unselectedTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
