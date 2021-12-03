import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  String language = "en";
  String units = "metric";

  setLanguage(String newLanguage) async {
    language = newLanguage;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", language);
    notifyListeners();
  }

  setUnits(String newUnits) async {
    units = newUnits;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("units", units);
    notifyListeners();
  }
}
