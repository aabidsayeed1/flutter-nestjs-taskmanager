// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:task_manager/app_imports.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// typedef OnDaySelected = void Function(DateTime selectedDay, DateTime focusedDay);

// class CustomTableCalendar extends StatelessWidget {
//   const CustomTableCalendar({
//     super.key,
//     this.selectedDay,
//     required this.onDaySelected,
//     this.startDate,
//     this.enabledDayPredicate,
//   });

//   final DateTime? selectedDay;
//   final DateTime? startDate;
//   final OnDaySelected onDaySelected;
//   final bool Function(DateTime day)? enabledDayPredicate;

//   @override
//   Widget build(BuildContext context) {
//     return TableCalendar(
//       availableGestures: AvailableGestures.horizontalSwipe,
//       firstDay: DateTime(2000),
//       lastDay: DateTime(2100),
//       focusedDay: selectedDay ?? DateTime.now(),
//       daysOfWeekHeight: 20.h,
//       selectedDayPredicate: (day) => isSameDay(day, selectedDay),
//       enabledDayPredicate:
//           enabledDayPredicate ??
//           (day) {
//             if (startDate != null) {
//               return !day.isBefore(startDate!);
//             }
//             return DateTime.now().isBefore(day.add(const Duration(days: 1)));
//           },
//       onDaySelected: (selectedDay, focusedDay) {
//         onDaySelected(selectedDay.toLocal(), focusedDay.toLocal());
//       },
//       daysOfWeekStyle: DaysOfWeekStyle(
//         dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
//         weekdayStyle: AppStyles.bodyTextBaseFontMediumNeutral400,
//         weekendStyle: AppStyles.bodyTextBaseFontMediumNeutral400,
//       ),
//       headerStyle: HeaderStyle(
//         formatButtonVisible: false,
//         titleTextStyle: AppStyles.bodyTextBaseFontMediumNeutral400,
//         leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.primary900),
//         rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.primary900),
//       ),
//       calendarStyle: CalendarStyle(
//         selectedTextStyle: AppStyles.bodyTextBaseFontMedium,
//         todayTextStyle: AppStyles.bodyTextBaseFontMedium,
//         defaultTextStyle: AppStyles.bodyTextBaseFontMediumNeutral300,
//         weekendTextStyle: AppStyles.bodyTextBaseFontMediumNeutral300,
//         todayDecoration: BoxDecoration(color: AppColors.neutral600, shape: BoxShape.circle),
//         selectedDecoration: BoxDecoration(color: AppColors.primary900, shape: BoxShape.circle),
//         outsideDaysVisible: false,
//         disabledTextStyle: AppStyles.bodyTextBaseFontMediumNeutral400,
//       ),
//     );
//   }
// }
