import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_values.dart';
import 'package:flutter/material.dart';
//============================================================================

class AppThemes {
  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary900,
    fontFamily: "Inter",
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    textTheme: const TextTheme(
      titleSmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      displayLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.ACTION_BUTTON_CORNERRAIUS),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.primary900,
      selectionHandleColor: AppColors.primary900,
      cursorColor: AppColors.primary900,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: AppColors.primary900),
  );

  static final ligtTheme = ThemeData(
    primaryColor: AppColors.primary900,
    fontFamily: "Inter",
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    textTheme: const TextTheme(
      titleSmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      displayLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.ACTION_BUTTON_CORNERRAIUS),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.primary900,
      selectionHandleColor: AppColors.primary900,
      cursorColor: AppColors.primary900,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: AppColors.primary900),
  );
}
