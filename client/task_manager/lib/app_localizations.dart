import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // static member to have simple access to the delegate from the Material app
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  late Map<String, String> _strLocalizedData;

  Future<bool> load() async {
    // Load the lang json file from the lang folder
    String strJSON = await rootBundle.loadString('lang/${locale.languageCode}.json');
    // Create json map
    Map<String, dynamic> jsonMap = json.decode(strJSON);
    // Transform dynamic to string
    _strLocalizedData = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This function will be called from every widget that needs localized text
  String translate(String strKey, {Map<String, String>? args}) {
    String translatedString = _strLocalizedData[strKey] ?? strKey;

    if (args != null) {
      args.forEach((key, value) {
        translatedString = translatedString.replaceAll('{$key}', value);
      });
    }

    return translatedString;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'hi', 'mr', 'kn', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
