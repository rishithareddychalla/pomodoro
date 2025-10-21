// import 'package:flutter/material.dart';

// class AppTheme {
//   final String name;
//   final ThemeData lightTheme;
//   final ThemeData darkTheme;

//   AppTheme({
//     required this.name,
//     required this.lightTheme,
//     required this.darkTheme,
//   });
// }

// final List<AppTheme> appThemes = [
//   AppTheme(
//     name: 'Default',
//     lightTheme: ThemeData.light().copyWith(
//       colorScheme: const ColorScheme.light(
//         primary: Color(0xFF3B82F6), // blue-500
//         onPrimary: Colors.white,
//         secondary: Color(0xFFF59E0B), // amber-500
//         onSecondary: Colors.black,
//         surface: Color(0xFFF8FAFC), // slate-50
//         onSurface: Color(0xFF1E293B), // slate-800
//       ),
//     ),
//     darkTheme: ThemeData.dark().copyWith(
//       colorScheme: const ColorScheme.dark(
//         primary: Color(0xFF60A5FA), // blue-400
//         onPrimary: Colors.black,
//         secondary: Color(0xFFFCD34D), // amber-300
//         onSecondary: Colors.black,
//         surface: Color(0xFF0F172A), // slate-900
//         onSurface: Colors.white,
//       ),
//     ),
//   ),

//   AppTheme(
//     name: 'Ocean',
//     lightTheme: ThemeData.light().copyWith(
//       colorScheme: const ColorScheme.light(
//         primary: Color(0xFF06B6D4), // cyan-500
//         onPrimary: Colors.white,
//         secondary: Color(0xFFFB7185), // rose-400
//         onSecondary: Colors.white,
//         surface: Color(0xFFF0FDFA), // cyan-50
//         onSurface: Color(0xFF164E63), // cyan-900
//       ),
//     ),
//     darkTheme: ThemeData.dark().copyWith(
//       colorScheme: const ColorScheme.dark(
//         primary: Color(0xFF22D3EE), // cyan-400
//         onPrimary: Colors.black,
//         secondary: Color(0xFFFDA4AF), // rose-300
//         onSecondary: Colors.black,
//         surface: Color(0xFF083344), // cyan-950
//         onSurface: Colors.white,
//       ),
//     ),
//   ),

//   AppTheme(
//     name: 'Forest',
//     lightTheme: ThemeData.light().copyWith(
//       colorScheme: const ColorScheme.light(
//         primary: Color(0xFF16A34A), // green-600
//         onPrimary: Colors.white,
//         secondary: Color(0xFFFBBF24), // amber-400
//         onSecondary: Colors.black,
//         surface: Color(0xFFF7FEE7), // green-50
//         onSurface: Color(0xFF14532D), // green-900
//       ),
//     ),
//     darkTheme: ThemeData.dark().copyWith(
//       colorScheme: const ColorScheme.dark(
//         primary: Color(0xFF4ADE80), // green-400
//         onPrimary: Colors.black,
//         secondary: Color(0xFFFACC15), // amber-300
//         onSecondary: Colors.black,
//         surface: Color(0xFF052E16), // green-950
//         onSurface: Colors.white,
//       ),
//     ),
//   ),
// ];
// // put this in a constants.dart or inside your theme file
// const List<Color> aestheticColors = [
//   // Blues & Cyans
//   Color.fromARGB(255, 96, 140, 211), // blue-500
//   Color.fromARGB(255, 100, 156, 221), // blue-400
//   Color.fromARGB(255, 107, 165, 175), // cyan-500
//   Color(0xFF22D3EE), // cyan-400
//   // Greens
//   Color.fromARGB(255, 85, 167, 115), // green-600
//   Color.fromARGB(255, 126, 218, 159), // green-400
//   Color.fromARGB(255, 122, 184, 163), // emerald-500
//   Color.fromARGB(255, 129, 199, 173), // emerald-400
//   // Purples / Pink
//   Color(0xFF8B5CF6), // violet-500
//   Color(0xFFA78BFA), // violet-400
//   Color(0xFFEC4899), // pink-500
//   Color(0xFFF472B6), // pink-400
//   // Amber / Orange
//   Color(0xFFF59E0B), // amber-500
//   Color(0xFFFCD34D), // amber-300
//   Color(0xFFFB923C), // orange-400
//   Color(0xFFFFA500), // custom orange
//   // Reds
//   Color(0xFFDC2626), // red-600
//   Color(0xFFF87171), // red-400
//   // Neutrals / Slate
//   // Color(0xFFF8FAFC), // slate-50
//   // Color(0xFFE2E8F0), // slate-200
//   Color(0xFF94A3B8), // slate-400
//   Color(0xFF1E293B), // slate-800
//   Color.fromARGB(255, 59, 75, 112), // slate-900
// ];
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
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3B82F6),
        onPrimary: Colors.white,
        secondary: Color(0xFFF59E0B),
        onSecondary: Colors.black,
        surface: Color(0xFFF8FAFC),
        onSurface: Color(0xFF1E293B),
        background: Color(0xFFF0F4F8),
        onBackground: Color(0xFF1E293B),
        surfaceVariant: Color(0xFFE2E8F0),
        onSurfaceVariant: Color(0xFF475569),
      ),
      scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: Color(0xFF1E293B),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF60A5FA),
        onPrimary: Colors.black,
        secondary: Color(0xFFFCD34D),
        onSecondary: Colors.black,
        surface: Color(0xFF0F172A),
        onSurface: Colors.white,
        background: Color(0xFF0A0E1A),
        onBackground: Colors.white,
        surfaceVariant: Color(0xFF1E293B),
        onSurfaceVariant: Colors.white70,
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0E1A),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF60A5FA),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
  ),
  AppTheme(
    name: 'Ocean',
    lightTheme: ThemeData.light().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF06B6D4),
        onPrimary: Colors.white,
        secondary: Color(0xFFFB7185),
        onSecondary: Colors.white,
        surface: Color(0xFFF0FDFA),
        onSurface: Color(0xFF164E63),
        background: Color(0xFFE6F7FA),
        onBackground: Color(0xFF164E63),
        surfaceVariant: Color(0xFFB2EBF2),
        onSurfaceVariant: Color(0xFF0E7490),
      ),
      scaffoldBackgroundColor: const Color(0xFFE6F7FA),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF0FDFA),
        foregroundColor: Color(0xFF164E63),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF06B6D4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF22D3EE),
        onPrimary: Colors.black,
        secondary: Color(0xFFFDA4AF),
        onSecondary: Colors.black,
        surface: Color(0xFF083344),
        onSurface: Colors.white,
        background: Color(0xFF051F2B),
        onBackground: Colors.white,
        surfaceVariant: Color(0xFF164E63),
        onSurfaceVariant: Colors.white70,
      ),
      scaffoldBackgroundColor: const Color(0xFF051F2B),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF083344),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF22D3EE),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
  ),
  AppTheme(
    name: 'Forest',
    lightTheme: ThemeData.light().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF16A34A),
        onPrimary: Colors.white,
        secondary: Color(0xFFFBBF24),
        onSecondary: Colors.black,
        surface: Color(0xFFF7FEE7),
        onSurface: Color(0xFF14532D),
        background: Color(0xFFE7F5E7),
        onBackground: Color(0xFF14532D),
        surfaceVariant: Color(0xFFA3E635),
        onSurfaceVariant: Color(0xFF1A7F3F),
      ),
      scaffoldBackgroundColor: const Color(0xFFE7F5E7),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF7FEE7),
        foregroundColor: Color(0xFF14532D),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF16A34A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4ADE80),
        onPrimary: Colors.black,
        secondary: Color(0xFFFACC15),
        onSecondary: Colors.black,
        surface: Color(0xFF052E16),
        onSurface: Colors.white,
        background: Color(0xFF031A0D),
        onBackground: Colors.white,
        surfaceVariant: Color(0xFF14532D),
        onSurfaceVariant: Colors.white70,
      ),
      scaffoldBackgroundColor: const Color(0xFF031A0D),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF052E16),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4ADE80),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
  ),
  AppTheme(
    name: 'Sunset',
    lightTheme: ThemeData.light().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFEF6C00),
        onPrimary: Colors.white,
        secondary: Color(0xFF8B5CF6),
        onSecondary: Colors.white,
        surface: Color(0xFFFFF7E6),
        onSurface: Color(0xFF4B2C20),
        background: Color(0xFFFFEFD5),
        onBackground: Color(0xFF4B2C20),
        surfaceVariant: Color(0xFFFBCAA4),
        onSurfaceVariant: Color(0xFF6B4E31),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFEFD5),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFFFF7E6),
        foregroundColor: Color(0xFF4B2C20),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF6C00),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF8C00),
        onPrimary: Colors.black,
        secondary: Color(0xFFA78BFA),
        onSecondary: Colors.black,
        surface: Color(0xFF2D1B0F),
        onSurface: Colors.white,
        background: Color(0xFF1F1209),
        onBackground: Colors.white,
        surfaceVariant: Color(0xFF4B2C20),
        onSurfaceVariant: Colors.white70,
      ),
      scaffoldBackgroundColor: const Color(0xFF1F1209),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF2D1B0F),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF8C00),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ),
  ),
];

const List<Color> aestheticColors = [
  Color(0xFF3B82F6),
  Color(0xFF60A5FA),
  Color(0xFF06B6D4),
  Color(0xFF22D3EE),
  Color(0xFF16A34A),
  Color(0xFF4ADE80),
  Color(0xFF10B981),
  Color(0xFF34D399),
  Color(0xFF8B5CF6),
  Color(0xFFA78BFA),
  Color(0xFFEC4899),
  Color(0xFFF472B6),
  Color(0xFFF59E0B),
  Color(0xFFFCD34D),
  Color(0xFFFB923C),
  Color(0xFFFFA500),
  Color(0xFFDC2626),
  Color(0xFFF87171),
  Color(0xFFEF6C00),
  Color(0xFFFF8C00),
  Color(0xFF94A3B8),
  Color(0xFF1E293B),
];
