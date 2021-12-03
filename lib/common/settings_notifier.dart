import 'package:flutter/cupertino.dart';

class SettingsModel extends ChangeNotifier {
  String language = "en";
  String units = "metric";

  setLanguage(String newLanguage) {
    language = newLanguage;
    notifyListeners();
  }

  setUnits(String newUnits) {
    units = newUnits;
    notifyListeners();
  }
}
