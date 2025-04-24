import 'dart:async';

import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  const Pagination({
    Key? key,
    required this.pagesCount,
    this.initialSelectedPage = 1,
    required this.onPageChanged,
    this.activeTextStyle,
    this.activeBtnStyle,
    this.inactiveTextStyle,
    this.inactiveBtnStyle,
    this.itemPadding = AppValues.PAGINATION_BUTTON_PADDING,
    this.visibleButtonCount = AppValues.PAGINATION_DEFAULT_BUTTON_COUNT,
  }) : super(key: key);

  final int pagesCount;
  final int initialSelectedPage;
  final int visibleButtonCount;
  final Function onPageChanged;
  final TextStyle? activeTextStyle;
  final ButtonStyle? activeBtnStyle;
  final TextStyle? inactiveTextStyle;
  final ButtonStyle? inactiveBtnStyle;
  final double itemPadding;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final StreamController<int> _indexStreamController = StreamController();
  late int selectedPage = widget.initialSelectedPage;

  late int _startPage;
  late int _endPage;

  @override
  void initState() {
    super.initState();
    _calculateVisiblePages();
  }

  void _calculateVisiblePages() {
    if (widget.pagesCount <= widget.visibleButtonCount) {
      _startPage = 1;
      _endPage = widget.pagesCount;
    } else {
      int middle = (widget.visibleButtonCount - 1) ~/ 2;
      if (selectedPage <= middle + 1) {
        _startPage = 1;
        _endPage = widget.visibleButtonCount;
      } else if (selectedPage >= widget.pagesCount - middle) {
        _startPage = widget.pagesCount - (widget.visibleButtonCount - 1);
        _endPage = widget.pagesCount;
      } else {
        _startPage = selectedPage - middle;
        _endPage = selectedPage + middle;
      }
    }
  }

  ButtonStyle _buttonStyle({bool isActive = true}) {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(AppValues.PAGINATION_BUTTON_ELEVATION),
      backgroundColor: const WidgetStatePropertyAll(AppColors.PAGINATION_BUTTON_BG),
      side: WidgetStateProperty.all(
        BorderSide(
          color:
              isActive
                  ? AppColors.PAGINATION_ACTIVE_BUTTON_BORDER
                  : AppColors.PAGINATION_INACTIVE_BUTTON_BORDER,
          width: AppValues.PAGINATION_BUTTON_BORDER_WIDTH,
          style: BorderStyle.solid,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.PAGINATION_BUTTON_RADIUS),
        ),
      ),
    );
  }

  ButtonStyle _controlButtonStyle({bool isActive = true}) {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(AppValues.PAGINATION_BUTTON_ELEVATION),
      backgroundColor: const WidgetStatePropertyAll(AppColors.PAGINATION_BUTTON_BG),
      side: WidgetStateProperty.all(
        BorderSide(
          color:
              isActive
                  ? AppColors.PAGINATION_INACTIVE_BUTTON_BORDER
                  : AppColors.PAGINATION_INACTIVE_BUTTON_BORDER.withOpacity(
                    AppValues.PAGINATION_BUTTON_BORDER_OPACITY,
                  ),
          width: AppValues.PAGINATION_BUTTON_BORDER_WIDTH,
          style: BorderStyle.solid,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.PAGINATION_BUTTON_RADIUS),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.PAGINATION,
      child: StreamBuilder<int>(
        stream: _indexStreamController.stream,
        initialData: selectedPage,
        builder: (context, snapshot) {
          selectedPage = snapshot.data!;
          _calculateVisiblePages();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AppValues.PAGINATION_BUTTON_WEIGHT,
                height: AppValues.PAGINATION_BUTTON_HEIGHT,
                child: TextButton(
                  style: _controlButtonStyle(isActive: selectedPage > 1),
                  onPressed:
                      selectedPage > 1
                          ? () {
                            _indexStreamController.add(selectedPage - 1);
                            widget.onPageChanged(selectedPage - 1);
                          }
                          : null,
                  child: Image.asset(
                    AppImages.PAGINATION_LEFT_ARROW,
                    color: selectedPage > 1 ? null : AppColors.PAGINATION_INACTIVE_ICON,
                    height: AppValues.PAGINATION_ICON_HEIGHT,
                  ),
                ),
              ),
              for (int i = _startPage; i <= _endPage; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: AppValues.PAGINATION_ANIM_DURATION_MS),
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.itemPadding, right: widget.itemPadding),
                    child: SizedBox(
                      width: AppValues.PAGINATION_BUTTON_WEIGHT,
                      height: AppValues.PAGINATION_BUTTON_HEIGHT,
                      child: TextButton(
                        style:
                            i == selectedPage
                                ? widget.activeBtnStyle ?? _buttonStyle()
                                : widget.inactiveBtnStyle ?? _buttonStyle(isActive: false),
                        onPressed: () {
                          _indexStreamController.add(i);

                          widget.onPageChanged(i);
                        },
                        child: Text(
                          '$i',
                          style:
                              i == selectedPage
                                  ? widget.activeTextStyle ?? AppStyles.paginationTextStyle
                                  : widget.inactiveTextStyle ?? AppStyles.paginationTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                width: AppValues.PAGINATION_BUTTON_WEIGHT,
                height: AppValues.PAGINATION_BUTTON_HEIGHT,
                child: TextButton(
                  style: _controlButtonStyle(isActive: (selectedPage < widget.pagesCount)),
                  onPressed:
                      selectedPage < widget.pagesCount
                          ? () {
                            _indexStreamController.add(selectedPage + 1);
                            widget.onPageChanged(selectedPage + 1);
                          }
                          : null,
                  child: Image.asset(
                    AppImages.PAGINATION_RIGHT_ARROW,
                    color:
                        selectedPage < widget.pagesCount
                            ? null
                            : AppColors.PAGINATION_INACTIVE_ICON,
                    height: AppValues.PAGINATION_ICON_HEIGHT,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
