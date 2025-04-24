import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager/app_imports.dart';
import 'package:intl/intl.dart';
class DateTimeManager {
  // Get the specified order or rank of a date
  static String getDateOrdinalSuffix(int nDay) {
    if (nDay > 10 && nDay < 20) {
      return '${nDay}th';
    }
    switch (nDay % 10) {
      case 1:
        return '${nDay}st';
      case 2:
        return '${nDay}nd';
      case 3:
        return '${nDay}rd';
      default:
        return '${nDay}th';
    }
  }

  static String formatHour(int hour) {
    if (hour == 24) return '23:59';
    return hour.toString().padLeft(2, '0') + ':00';
  }

  static String convertDateTimeToOrdinalFormat(String inputDate, {bool bConvertToLocal = false}) {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateTime.parse(inputDate);

    if (bConvertToLocal == true) {
      dateTime = dateTime.toLocal();
    }

    // Format the day with ordinal suffix
    String dayWithSuffix(int day) {
      if (day >= 11 && day <= 13) {
        return '${day}th'; // Special case for 11th, 12th, 13th
      }
      switch (day % 10) {
        case 1:
          return '${day}st';
        case 2:
          return '${day}nd';
        case 3:
          return '${day}rd';
        default:
          return '${day}th';
      }
    }

    String day = dayWithSuffix(dateTime.day); // Get day with suffix
    String month = DateFormat('MMM').format(dateTime); // Month abbreviation
    String year = DateFormat('yyyy').format(dateTime); // Year
    String time = DateFormat('h:mm a').format(dateTime.toLocal()); // Time in 12-hour format

    return '$day $month $year, $time';
  }

  static String getDayDateFormat(String strDate, String strDateFormat) {
    dynamic dayData =
        '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';

    dynamic monthData =
        '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';

    if (strDate.isEmpty) {
      return '';
    }

    DateTime dateTime = DateTime.parse(strDate);

    return json.decode(dayData)['${dateTime.weekday}'] +
        ", " +
        dateTime.day.toString() +
        " " +
        json.decode(monthData)['${dateTime.month}'] +
        " " +
        dateTime.year.toString();
  }

  static String getYearMonthDarFormatFromDateTime(DateTime value) {
    String strFormattedDate = DateFormat(AppStrings.STRING_YEAR_MONTH_DATE).format(value);

    return strFormattedDate;
  }

  static String getDateFormat(String strDate, String strDateFormat) {
    dynamic monthData =
        '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';

    if (strDate.isEmpty) {
      return '';
    }

    DateTime dateTime = DateTime.parse(strDate);

    return dateTime.day.toString() +
        " " +
        json.decode(monthData)['${dateTime.month}'] +
        ", " +
        dateTime.year.toString();
  }

  static String getTimeFormat(int nTime) {
    String strFormattedTime = '';

    if (nTime > 11) {
      strFormattedTime = (nTime - 12).toString() + " " + "PM";
    } else {
      strFormattedTime = nTime.toString() + " " + "AM";
    }

    return strFormattedTime;
  }

  static String getTimeRangeFormat(int nStartTime, int nEndTime) {
    String strStartTime = '';
    String strEndTime = '';
    String strFormattedTime = '';

    if (nStartTime >= 12) {
      if (nStartTime == 12) {
        strStartTime = nStartTime.toString();
      } else {
        strStartTime = (nStartTime - 12).toString();
      }
    } else {
      strStartTime = nStartTime.toString();
    }

    if (nEndTime >= 12) {
      if (nEndTime == 12) {
        strEndTime = nEndTime.toString() + " " + "PM";
      } else {
        strEndTime = (nEndTime - 12).toString() + " " + "PM";
      }
    } else {
      strEndTime = nEndTime.toString() + " " + "AM";
    }

    strFormattedTime = strStartTime + "-" + strEndTime;
    return strFormattedTime;
  }

  static getDateFormatFromDateTime(String strDate) {
    String strFormattedDate = '';

    strFormattedDate = strDate;

    return strFormattedDate;
  }

  static String getTimeFormatFromDateTime(String strDate) {
    if (strDate.isEmpty) {
      return '';
    }

    DateTime dateTime = DateTime.parse(strDate);
    DateFormat dateFormat = DateFormat("h:mm aa");
    String strTimeFormatted = dateFormat.format(dateTime.toLocal());

    return strTimeFormatted;
  }

  static String timeAgoSinceDate(String strDate, {bool numericDates = true}) {
    if (strDate.isEmpty) {
      return '';
    }

    DateTime notificationDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(strDate);

    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      strDate = getDateMonthFormat(strDate, 'dd/MM/yy');
      return strDate;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  static String getDateMonthFormat(String strDate, String strDateFormat) {
    if (strDate.isEmpty) {
      return '';
    }

    DateTime dateTime = DateTime.parse(strDate);
    String strDateFormatted = DateFormat(strDateFormat).format(dateTime);

    return strDateFormatted;
  }

  static String formatDateTimeRange({
    DateTime? startDate,
    required DateTime? startTime,
    DateTime? endDate,
    required DateTime? endTime,
  }) {
    if (startTime == null || endTime == null) {
      return "Invalid Time";
    }

    // Combine startDate with startTime if startDate is provided
    final startDateTime =
        startDate != null
            ? DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
              startTime.hour,
              startTime.minute,
            )
            : startTime;

    // Combine endDate with endTime if endDate is provided
    final endDateTime =
        endDate != null
            ? DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute)
            : endTime;

    // Define formats
    final dateFormat = DateFormat('d MMM');
    final timeFormat = DateFormat('hh:mm a');

    // Check if dates are provided
    final startDateStr = startDate != null ? "${dateFormat.format(startDateTime)} " : "";
    final endDateStr = endDate != null ? "${dateFormat.format(endDateTime)} " : "";

    return "$startDateStr${timeFormat.format(startDateTime)} - $endDateStr${timeFormat.format(endDateTime)}";
  }

  static String generateTimeStatus(String date, String fromTime, String toTime) {
    DateTime now = DateTime.now();

    // DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);

    DateTime fromDateTime = DateFormat('dd-MM-yyyy hh:mm a').parse('$date $fromTime');
    DateTime toDateTime = DateFormat('dd-MM-yyyy hh:mm a').parse('$date $toTime');

    if (now.isAfter(fromDateTime) && now.isBefore(toDateTime)) {
      return 'Ongoing';
    } else if (now.isAfter(toDateTime)) {
      return 'Ended';
    } else {
      Duration difference = fromDateTime.difference(now);

      if (difference.inMinutes < 60) {
        return 'In ${difference.inMinutes} minutes';
      } else if (difference.inHours < 24) {
        return 'In ${difference.inHours} hours';
      } else if (difference.inDays == 1) {
        return 'In 1 day';
      } else {
        return 'In ${difference.inDays} days';
      }
    }
  }

  static String generateDateLabel(String date) {
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    String dayWithSuffix = _getDayWithSuffix(parsedDate.day);

    if (parsedDate.isAtSameMomentAs(today)) {
      return 'Today ($dayWithSuffix ${DateFormat('MMM').format(parsedDate)})';
    } else if (parsedDate.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow ($dayWithSuffix ${DateFormat('MMM').format(parsedDate)})';
    } else {
      return '$dayWithSuffix ${DateFormat('MMM').format(parsedDate)}';
    }
  }

  static String formatDateMMMyy(DateTime date) {
    return DateFormat("MMM 'yy").format(date);
  }

  static String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final comparisonDate = DateTime(date.year, date.month, date.day);

    if (comparisonDate == today) {
      return 'Today';
    } else if (comparisonDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (comparisonDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('E').format(date);
    }
  }

  static String formatDateTimeToIST(DateTime dateTime) {
    const istOffset = Duration(hours: 5, minutes: 30);
    final istDateTime = dateTime.toUtc().add(istOffset);
    final formattedDateTime = "${istDateTime.toIso8601String().split('.')[0]}+05:30";
    return Uri.encodeComponent(formattedDateTime);
  }
}

extension TimeOfDayFormatterForDateTime on DateTime {
  String formatTime() {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat('hh:mm a').format(dateTime);
  }
}

extension TimeOfDayFormatter on TimeOfDay {
  String formatTime() {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat('hh:mm a').format(dateTime);
  }
}

extension DateTimeFormatter on DateTime {
  String formatDate() {
    return DateFormat('EEE d MMM').format(this);
  }
}

extension DateTimeFormatterMMMyy on DateTime {
  String formatDateMMMyy() {
    return DateFormat("MMM '\u2019'yy").format(this);
  }
}

extension DateTimeDayAndWeek on DateTime {
  // Method to format a single day (e.g., "Today (29th Oct)")
  String formatDay() {
    final day = this.day;
    final month = this.month;
    return "(${_getDaySuffix(day)} ${_getMonthName(month)})";
  }

  // Method to format a single day (e.g., "Today (07 Oct)")
  String formatDayVariant() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month;
    return "$day ${_getMonthName(month)}";
  }

  // Method to format a week (e.g., "27 Oct - 2 Nov")
  String formatWeek(DateTime startOfWeek, DateTime endOfWeek) {
    final startDay = startOfWeek.day;
    final startMonth = startOfWeek.month;
    final endDay = endOfWeek.day;
    final endMonth = endOfWeek.month;
    return "$startDay ${_getMonthName(startMonth)} - $endDay ${_getMonthName(endMonth)}";
  }

  // Helper method to get the day suffix (e.g., 1st, 2nd, 3rd, etc.)
  String _getDaySuffix(int day) {
    if (day == 1 || day == 21 || day == 31) {
      return "${day}st";
    } else if (day == 2 || day == 22) {
      return "${day}nd";
    } else if (day == 3 || day == 23) {
      return "${day}rd";
    } else {
      return "${day}th";
    }
  }

  // Helper method to get the month name (e.g., "Jan", "Feb", etc.)
  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}

extension DateTimeFormatting on DateTime {
  DateTime toIST() {
    if (isUtc) {
      return add(const Duration(hours: 5, minutes: 30));
    }
    return this;
  }

  /// Formats the DateTime to:
  /// - 'Wed, Nov 6' if the date is not within the same day or past 24 hours.
  /// - '09:00 AM' if it's the same day or within the last 24 hours.
  String formatDateTime() {
    final now = DateTime.now();
    final isSameDay = now.year == year && now.month == month && now.day == day;
    final differenceInHours = now.difference(this).inHours;

    if (isSameDay || differenceInHours < 24) {
      return _formatAsTime();
    } else {
      return _formatAsDayAndMonth();
    }
  }

  /// Helper method to format as '09:00 AM'.
  String _formatAsTime() {
    final hour = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Helper method to format as 'Wed, Nov 6'.
  String _formatAsDayAndMonth() {
    final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final dayOfWeek = daysOfWeek[weekday % 7];
    final month = months[this.month - 1];
    return '$dayOfWeek, $month $day';
  }
}
