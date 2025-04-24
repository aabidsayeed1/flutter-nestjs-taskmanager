import 'package:flutter/material.dart';

enum AppTheme { lightTheme, darkTheme }

class AppThemes {
  static final appThemeData = {
    AppTheme.darkTheme: ThemeData(
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      dividerColor: Colors.black54,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.white)),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
      ),
      textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.white)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.grey,
        unselectedItemColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark, 
      ).copyWith(surface: const Color(0xFF212121)),
    ),

    //
    //
    AppTheme.lightTheme: ThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.light,
      dividerColor: const Color(0xff757575),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.black)),
      ),
      textTheme: TextTheme(titleMedium: TextStyle(color: Colors.black)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
     colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.grey,
        brightness: Brightness.light, 
      ).copyWith(
        surface: const Color(0xFFE5E5E5),
      ),
    ),
  };
}
