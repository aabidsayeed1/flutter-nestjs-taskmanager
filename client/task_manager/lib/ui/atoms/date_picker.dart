import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final String strLabel;
  final TextStyle? labelStyle;
  final DateTime? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateRangePickerController controller;
  final DataPickerTypes dataPickerType;
  final Function(dynamic)? onClickDate;
  final List<DateTime> disabledDates;
  final List<DateTime> eventDates;
  final TextStyle? headerStyle;
  final TextStyle? headerWeeksStyle;
  final TextStyle? disabledDatesStyle;
  final Color selDayBgColor;
  final TextStyle? selDayStyle;
  final Color todayDateBgColor;
  final TextStyle? todayDateStyle;
  final TextStyle? normalDateStyle;
  final double dBorderRadius;
  final Color footerTodayColor;
  final Color rangeColor;
  final double dInputHeight;
  final double dInputRadius;
  final Color inputBorderColor;
  final TextStyle? inputTextStyle;
  final bool isDisabled;
  final double? monthDateCellHeight;
  final double? monthDateCellWidth;
  final Color eventDotColor;
  final Color selectedColor;
  final Color eventDatesBgColor;

  const DatePicker({
    Key? key,
    this.strLabel = "",
    this.labelStyle,
    this.selectedDate,
    this.minDate,
    this.maxDate,
    required this.controller,
    this.dataPickerType = DataPickerTypes.normal,
    this.onClickDate,
    this.disabledDates = const [],
    this.headerStyle,
    this.headerWeeksStyle,
    this.eventDates = const [],
    this.disabledDatesStyle,
    this.selDayBgColor = AppColors.DATE_PICKER_SELECTED_BG_COLOR,
    this.selDayStyle,
    this.todayDateBgColor = AppColors.DATE_PICKER_TODAY_DATE_BG_COLOR,
    this.todayDateStyle,
    this.dBorderRadius = AppValues.DATE_PICKER_CELL_RADIUS,
    this.footerTodayColor = AppColors.DATE_PICKER_FOOTER_TODAY_COLOR,
    this.rangeColor = AppColors.DATE_PICKER_RANGE_COLOR,
    this.dInputHeight = AppValues.DATE_PICKER_INPUT_HEIGHT,
    this.dInputRadius = AppValues.DATE_PICKER_INPUT_RADIUS,
    this.inputBorderColor = AppColors.DATE_PICKER_INPUT_BORDER_COLOR,
    this.inputTextStyle,
    this.isDisabled = false,
    this.monthDateCellHeight = AppValues.DATE_PICKER_MONTH_DATE_CELL_HEIGHT,
    this.monthDateCellWidth = AppValues.DATE_PICKER_MONTH_DATE_CELL_WIDTH,
    this.eventDotColor = AppColors.DATE_PICKER_EVENT_DOT_COLOR,
    this.selectedColor = AppColors.DATE_PICKER_SELECTED_COLOR,
    this.normalDateStyle,
    this.eventDatesBgColor = Colors.transparent,
  }) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String inputText = "";
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      inputText = _dateTimeConversion(widget.selectedDate ?? DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.DATE_PICKER,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.strLabel.isNotEmpty)
            Text(widget.strLabel, style: widget.labelStyle ?? AppStyles.datePickerLabelStyle),
          if (widget.strLabel.isNotEmpty) Gap(8),
          GestureDetector(
            onTap: () {
              if (!widget.isDisabled) {
                setState(() {
                  isVisible = !(isVisible);
                });
              }
            },
            child: Container(
              height: widget.dInputHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.dInputRadius),
                border: Border.all(color: widget.inputBorderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    inputText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: widget.inputTextStyle ?? AppStyles.datePickerInputTextStyle,
                  ),
                ),
              ),
            ),
          ),
          Gap(4),
          if (isVisible) _overlayDatePicker(),
        ],
      ),
    );
  }

  Widget _overlayDatePicker() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.dInputRadius),
        border: Border.all(color: widget.inputBorderColor),
      ),
      child: SfDateRangePicker(
        initialSelectedDate: widget.selectedDate,
        showNavigationArrow: true,
        showTodayButton: true,
        maxDate: widget.maxDate,
        minDate: widget.minDate,
        onSelectionChanged: _onSelectionDate,
        selectionColor: Colors.transparent,
        //selectionShape: DateRangePickerSelectionShape.rectangle,
        todayHighlightColor: widget.footerTodayColor,
        startRangeSelectionColor: Colors.transparent,
        endRangeSelectionColor: Colors.transparent,
        rangeSelectionColor: Colors.transparent,
        cellBuilder: (BuildContext context, DateRangePickerCellDetails cellDetails) {
          return _cellBuilder(context, cellDetails);
        },

        headerStyle: DateRangePickerHeaderStyle(
          textStyle: widget.headerStyle ?? AppStyles.datePickerHeaderStyle,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          blackoutDateTextStyle:
              widget.disabledDatesStyle ?? AppStyles.datePickerDisabledDatesStyle,
          todayTextStyle: widget.todayDateStyle ?? AppStyles.datePickerTodayDateStyle,
          specialDatesDecoration: BoxDecoration(
            color: widget.eventDatesBgColor,
            borderRadius: BorderRadius.circular(widget.dBorderRadius),
          ),
          todayCellDecoration: BoxDecoration(
            color: widget.todayDateBgColor,
            borderRadius: BorderRadius.circular(widget.dBorderRadius),
          ),
        ),
        monthViewSettings: DateRangePickerMonthViewSettings(
          dayFormat: 'E',
          showTrailingAndLeadingDates: true,
          blackoutDates: widget.disabledDates,
          specialDates: widget.eventDates,
          viewHeaderStyle: DateRangePickerViewHeaderStyle(
            textStyle: widget.headerWeeksStyle ?? AppStyles.datePickerHeaderWeeksStyle,
          ),
        ),
        view: DateRangePickerView.month,
        controller: widget.controller,
        selectionMode:
            widget.dataPickerType == DataPickerTypes.range
                ? DateRangePickerSelectionMode.range
                : DateRangePickerSelectionMode.single,
      ),
    );
  }

  Widget _cellBuilder(BuildContext context, DateRangePickerCellDetails cellDetails) {
    if (widget.controller.view == DateRangePickerView.month) {
      return Align(
        child: Container(
          width: widget.monthDateCellWidth,
          height: widget.monthDateCellHeight,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.dBorderRadius),
            color:
                (_compareDates(widget.controller.selectedDate, cellDetails.date) ||
                        _compareDates(
                          widget.controller.selectedRange?.startDate,
                          cellDetails.date,
                        ) ||
                        _compareDates(widget.controller.selectedRange?.endDate, cellDetails.date))
                    ? widget.selDayBgColor
                    : (widget.controller.selectedRange?.startDate != null &&
                        cellDetails.date.isAfter(
                          widget.controller.selectedRange?.startDate ?? DateTime.now(),
                        ) &&
                        (widget.controller.selectedRange?.endDate != null &&
                            cellDetails.date.isBefore(
                              widget.controller.selectedRange?.endDate ?? DateTime.now(),
                            )))
                    ? widget.rangeColor
                    : (_compareDates(DateTime.now(), cellDetails.date))
                    ? widget.todayDateBgColor
                    : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                cellDetails.date.day.toString(),
                style:
                    (widget.disabledDates.contains(cellDetails.date))
                        ? (widget.disabledDatesStyle ?? AppStyles.datePickerDisabledDatesStyle)
                        : (widget.controller.selectedDate == cellDetails.date ||
                            (_compareDates(
                              widget.controller.selectedRange?.startDate,
                              cellDetails.date,
                            )) ||
                            (_compareDates(
                              widget.controller.selectedRange?.endDate,
                              cellDetails.date,
                            )))
                        ? (widget.selDayStyle ?? AppStyles.datePickerSelectedDayStyle)
                        : (widget.normalDateStyle ?? AppStyles.datePickerNormalDateTextStyle),
              ),
              if (widget.eventDates.contains(cellDetails.date))
                Container(
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color:
                        (widget.controller.selectedDate == cellDetails.date)
                            ? widget.selectedColor
                            : widget.eventDotColor,
                  ),
                ),
            ],
          ),
        ),
      );
    } else if (widget.controller.view == DateRangePickerView.year) {
      return Container(
        width: cellDetails.bounds.width,
        height: cellDetails.bounds.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.dBorderRadius),
          color:
              (widget.controller.selectedDate?.month == cellDetails.date.month)
                  ? widget.selDayBgColor
                  : null,
        ),
        child: Text(
          months[cellDetails.date.month.toString()] ?? "",
          style:
              (widget.controller.selectedDate?.month == cellDetails.date.month)
                  ? (widget.selDayStyle ?? AppStyles.datePickerSelectedDayStyle)
                  : null,
        ),
      );
    } else if (widget.controller.view == DateRangePickerView.decade) {
      return Container(
        width: cellDetails.bounds.width,
        height: cellDetails.bounds.height,
        alignment: Alignment.center,
        child: Text(cellDetails.date.year.toString()),
      );
    } else {
      final int yearValue = (cellDetails.date.year ~/ 10) * 10;
      return Align(
        child: Container(
          width: widget.monthDateCellWidth,
          height: widget.monthDateCellHeight,
          alignment: Alignment.center,
          child: Text('$yearValue - ${yearValue + 9}'),
        ),
      );
    }
  }

  void _onSelectionDate(DateRangePickerSelectionChangedArgs args) {
    if (widget.onClickDate != null && !widget.disabledDates.contains(args.value)) {
      widget.onClickDate!(args.value);
      String text = "";
      if (args.value is DateTime) {
        setState(() {
          inputText = _dateTimeConversion(args.value);
        });
      } else if (args.value is PickerDateRange) {
        text = _dateTimeConversion(args.value.startDate);
        if (args.value.endDate != null) {
          text += " to ${_dateTimeConversion(args.value.endDate)}";
        }
        setState(() {
          inputText = text;
        });
      }
    }
  }

  String _dateTimeConversion(DateTime dateTime) {
    var date = DateTime.parse(dateTime.toString());
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  }

  bool _compareDates(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) {
      return false;
    } else {
      return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
    }
  }

  Map<String, String> months = {
    "1": 'January',
    "2": 'February',
    "3": 'March',
    "4": 'April',
    "5": 'May',
    "6": 'June',
    "7": 'July',
    "8": 'August',
    "9": 'September',
    "10": 'October',
    "11": 'November',
    "12": 'December',
  };
}
