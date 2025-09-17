import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  AppTheme({
    required this.name,
    required this.lightTheme,
    required this.darkTheme,
  });
}

final List<AppTheme> appThemes = [
  AppTheme(
  name: 'Default',
  lightTheme: ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3B82F6), // blue-500
      onPrimary: Colors.white,
      secondary: Color(0xFFF59E0B), // amber-500
      onSecondary: Colors.black,
      surface: Color(0xFFF8FAFC), // slate-50
      onSurface: Color(0xFF1E293B), // slate-800
    ),
  ),
  darkTheme: ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF60A5FA), // blue-400
      onPrimary: Colors.black,
      secondary: Color(0xFFFCD34D), // amber-300
      onSecondary: Colors.black,
      surface: Color(0xFF0F172A), // slate-900
      onSurface: Colors.white,
    ),
  ),
),


  AppTheme(
  name: 'Ocean',
  lightTheme: ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF06B6D4), // cyan-500
      onPrimary: Colors.white,
      secondary: Color(0xFFFB7185), // rose-400
      onSecondary: Colors.white,
      surface: Color(0xFFF0FDFA), // cyan-50
      onSurface: Color(0xFF164E63), // cyan-900
    ),
  ),
  darkTheme: ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF22D3EE), // cyan-400
      onPrimary: Colors.black,
      secondary: Color(0xFFFDA4AF), // rose-300
      onSecondary: Colors.black,
      surface: Color(0xFF083344), // cyan-950
      onSurface: Colors.white,
    ),
  ),
),

  AppTheme(
  name: 'Forest',
  lightTheme: ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF16A34A), // green-600
      onPrimary: Colors.white,
      secondary: Color(0xFFFBBF24), // amber-400
      onSecondary: Colors.black,
      surface: Color(0xFFF7FEE7), // green-50
      onSurface: Color(0xFF14532D), // green-900
    ),
  ),
  darkTheme: ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4ADE80), // green-400
      onPrimary: Colors.black,
      secondary: Color(0xFFFACC15), // amber-300
      onSecondary: Colors.black,
      surface: Color(0xFF052E16), // green-950
      onSurface: Colors.white,
    ),
  ),
),

];
// put this in a constants.dart or inside your theme file
const List<Color> aestheticColors = [
  // Blues & Cyans
  Color(0xFF3B82F6), // blue-500
  Color(0xFF60A5FA), // blue-400
  Color(0xFF06B6D4), // cyan-500
  Color(0xFF22D3EE), // cyan-400

  // Greens
  Color(0xFF16A34A), // green-600
  Color(0xFF4ADE80), // green-400
  Color(0xFF10B981), // emerald-500
  Color(0xFF34D399), // emerald-400

  // Purples / Pink
  Color(0xFF8B5CF6), // violet-500
  Color(0xFFA78BFA), // violet-400
  Color(0xFFEC4899), // pink-500
  Color(0xFFF472B6), // pink-400

  // Amber / Orange
  Color(0xFFF59E0B), // amber-500
  Color(0xFFFCD34D), // amber-300
  Color(0xFFFB923C), // orange-400
  Color(0xFFFFA500), // custom orange

  // Reds
  Color(0xFFDC2626), // red-600
  Color(0xFFF87171), // red-400

  // Neutrals / Slate
  Color(0xFFF8FAFC), // slate-50
  Color(0xFFE2E8F0), // slate-200
  Color(0xFF94A3B8), // slate-400
  Color(0xFF1E293B), // slate-800
  Color(0xFF0F172A), // slate-900
];
