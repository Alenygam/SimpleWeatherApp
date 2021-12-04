import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  String language = "en";
  String units = "metric";

  /// [setPref] is true by default
  setLanguage(String newLanguage, [bool? setPref]) async {
    setPref ??= true;
    language = newLanguage;
    if (setPref) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("language", language);
    }
    notifyListeners();
  }

  /// [setPref] is true by default
  setUnits(String newUnits, [bool? setPref]) async {
    setPref ??= true;
    units = newUnits;
    if (setPref) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("units", units);
    }
    notifyListeners();
  }
}
