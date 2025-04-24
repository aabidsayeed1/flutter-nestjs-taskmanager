import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? _prefs;

  //==================================================
  // If _prefs is null
  static Future<SharedPreferences> get _prefInstance async =>
      _prefs ?? (await SharedPreferences.getInstance());

  // Call this during the start of your app so that we can get
  // the pref instance once and use the same each time
  static Future<SharedPreferences> init() async {
    _prefs = await _prefInstance;
    return _prefs!;
  }

  //==================================================
  static String getString(String? strKey) {
    String strValue = '';
    if (strKey != null && strKey.isNotEmpty && _prefs != null) {
      if (_prefs!.containsKey(strKey)) {
        strValue = _prefs!.getString(strKey) ?? "";
      }
    }
    return strValue;
  }

  static void setString(String? strKey, String? strValue) {
    if (strKey != null && strValue != null) {
      _prefs!.setString(strKey, strValue);
    }
  }

  //==================================================
  static int getInt(String? strKey) {
    int nValue = -1;
    if (strKey != null && strKey.isNotEmpty && _prefs != null) {
      if (_prefs!.containsKey(strKey)) {
        nValue = _prefs!.getInt(strKey)!;
      }
    }
    return nValue;
  }

  static void setInt(String? strKey, int nValue) {
    if (strKey != null) {
      _prefs!.setInt(strKey, nValue);
    }
  }

  //==================================================
  static double getDouble(String? strKey) {
    double dValue = -1;
    if (strKey != null && strKey.isNotEmpty && _prefs != null) {
      if (_prefs!.containsKey(strKey)) {
        dValue = _prefs!.getDouble(strKey)!;
      }
    }
    return dValue;
  }

  static void setDouble(String? strKey, double dValue) {
    if (strKey != null) {
      _prefs!.setDouble(strKey, dValue);
    }
  }

  //==================================================
  static bool getBool(String? strKey) {
    bool bValue = false;
    if (strKey != null && strKey.isNotEmpty && _prefs != null) {
      if (_prefs!.containsKey(strKey)) {
        bValue = _prefs!.getBool(strKey) ?? false;
      }
    }
    return bValue;
  }

  static void setBool(String? strKey, bool bValue) {
    if (strKey != null) {
      _prefs!.setBool(strKey, bValue);
    }
  }

  //==================================================
  static List<String> getStringList(String? strKey) {
    List<String> listOfValue = [];
    if (strKey != null && strKey.isNotEmpty && _prefs != null) {
      if (_prefs!.containsKey(strKey)) {
        listOfValue = _prefs!.getStringList(strKey)!;
      }
    }
    return listOfValue;
  }

  static void setStringList(String? strKey, List<String> listOfValue) {
    if (strKey != null) {
      _prefs!.setStringList(strKey, listOfValue);
    }
  }

  //==================================================
  static Object get(String? strKey) {
    Object obj = false;
    if (strKey != null && strKey.isNotEmpty && _prefs != null) {
      if (_prefs!.containsKey(strKey)) {
        obj = _prefs!.get(strKey)!;
      }
    }
    return obj;
  }

  static void removeKey(String strKey) async {
    if (strKey.isNotEmpty && _prefs != null) {
      if (_prefs!.containsKey(strKey)) {
        _prefs!.remove(strKey);
      }
    }
  }
}
