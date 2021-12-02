import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impostazioni"),
        centerTitle: true,
      ),
      body: ElevatedButton(
        child: const Text("premimi"),
        onPressed: () {
          Provider.of<SettingsModel>(context, listen: false).changeSetting();
        },
      ),
    );
  }
}
