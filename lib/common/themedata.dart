import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: Colors.blue,
    primaryVariant: Colors.blue,
    secondary: Colors.redAccent,
    secondaryVariant: Colors.redAccent,
    surface: Colors.black12,
    background: Colors.black26,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: Colors.blue,
    primaryVariant: Colors.blue,
    secondary: Colors.red,
    secondaryVariant: Colors.red,
    surface: Colors.white10,
    background: Colors.white24,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
);
