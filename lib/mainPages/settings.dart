import 'package:SimpleWeatherApp/common/languages.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:SimpleWeatherApp/common/units.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    SettingsModel settingsProvider = Provider.of<SettingsModel>(context);
    String language = settingsProvider.language;
    String unit = settingsProvider.units;

    List<Map<String, dynamic>> languageList = [];
    List<Map<String, dynamic>> unitList = [];

    for (String unit in unitNames.keys) {
      unitList.add({"value": unit, "label": unitNames[unit]});
    }

    for (String k in languages.keys) {
      languageList.add({
        "value": k,
        "label": languages[k]!.fullName,
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(languages[language]!.settings),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectFormField(
              initialValue: language,
              items: languageList,
              icon: Text(
                languages[language]!.language,
                style: const TextStyle(fontSize: 18.0),
              ),
              onChanged: (val) {
                settingsProvider.setLanguage(val);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectFormField(
              initialValue: unit,
              items: unitList,
              icon: Text(
                languages[language]!.unitOfMeasure,
                style: const TextStyle(fontSize: 18.0),
              ),
              onChanged: (val) {
                settingsProvider.setUnits(val);
              },
            ),
          )
        ],
      ),
    );
  }
}
