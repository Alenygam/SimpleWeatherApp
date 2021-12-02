import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottomnav.dart';
import 'package:SimpleWeatherApp/common/themedata.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const BottomNav(),
    );
  }
}
