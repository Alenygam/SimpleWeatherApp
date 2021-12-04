import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottomnav.dart';
import 'package:SimpleWeatherApp/common/themedata.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var language = prefs.getString("language");
    var units = prefs.getString("units");

    SettingsModel provider = Provider.of<SettingsModel>(context, listen: false);
    if (language != null) provider.setLanguage(language, false);
    if (units != null) provider.setUnits(units, false);
  }

  @override
  void initState() {
    initProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const BottomNav(),
    );
  }
}
