import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bottomnav.dart';
import 'package:SimpleWeatherApp/common/themedata.dart';

void main() {
  runApp(const MyApp());
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
