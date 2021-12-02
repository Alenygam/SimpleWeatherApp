import 'package:flutter/cupertino.dart';

class SettingsModel extends ChangeNotifier {
  var settings = {
    "banana": 1
  };

  changeSetting() {
    settings["banana"] = settings["banana"]! + 1;

    notifyListeners();
  }
}
