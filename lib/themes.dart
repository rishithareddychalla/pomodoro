import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final Color sampleColor;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  AppTheme({
    required this.name,
    required this.sampleColor,
    required this.lightTheme,
    required this.darkTheme,
  });
}

final List<AppTheme> appThemes = [
  AppTheme(
    name: 'Default',
    sampleColor: Colors.blue,
    lightTheme: ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      primaryColor: Colors.blue,
      colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
      ),
    ),
  ),
  AppTheme(
    name: 'Ocean',
    sampleColor: Colors.cyan,
    lightTheme: ThemeData.light().copyWith(
      primaryColor: Colors.cyan,
      colorScheme: const ColorScheme.light(
        primary: Colors.cyan,
        secondary: Colors.cyanAccent,
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      primaryColor: Colors.cyan,
      colorScheme: const ColorScheme.dark(
        primary: Colors.cyan,
        secondary: Colors.cyanAccent,
      ),
    ),
  ),
  AppTheme(
    name: 'Forest',
    sampleColor: Colors.green,
    lightTheme: ThemeData.light().copyWith(
      primaryColor: Colors.green,
      colorScheme: const ColorScheme.light(
        primary: Colors.green,
        secondary: Colors.greenAccent,
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      primaryColor: Colors.green,
      colorScheme: const ColorScheme.dark(
        primary: Colors.green,
        secondary: Colors.greenAccent,
      ),
    ),
  ),
    AppTheme(
    name: 'Custom',
    sampleColor: Colors.purple,
    lightTheme: ThemeData.light().copyWith(
      primaryColor: Colors.purple,
      colorScheme: const ColorScheme.light(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      primaryColor: Colors.purple,
      colorScheme: const ColorScheme.dark(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
      ),
    ),
  ),
];
