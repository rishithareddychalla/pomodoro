import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  AppTheme({required this.name, required this.lightTheme, required this.darkTheme});
}

final List<AppTheme> appThemes = [
  AppTheme(
    name: 'Default',
    lightTheme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
  ),
  AppTheme(
    name: 'Ocean',
    lightTheme: ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
  AppTheme(
    name: 'Forest',
    lightTheme: ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.dark,
    ),
  ),
];
