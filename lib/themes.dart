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
    lightTheme: ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.green,
        brightness: Brightness.light,
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.green,
        brightness: Brightness.dark,
      ),
    ),
  ),
  AppTheme(
    name: 'Ocean',
    lightTheme: ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.cyan,
        accentColor: Colors.deepOrange,
        brightness: Brightness.light,
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.cyan,
        accentColor: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
    ),
  ),
  AppTheme(
    name: 'Forest',
    lightTheme: ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.amber,
        brightness: Brightness.light,
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.amber,
        brightness: Brightness.dark,
      ),
    ),
  ),
];
