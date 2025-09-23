import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

class SettingsProvider with ChangeNotifier {
  String _selectedThemeName;
  bool _isDarkMode;
  String _timerName;
  bool _isVibrationEnabled;
  int _workSeconds;
  int _breakSeconds;
  String _alarmSound;

  // Custom theme colors
  Color? _customPrimary;
  Color? _customSecondary;

  ThemeData get themeData {
    if (_selectedThemeName == "Custom" &&
        _customPrimary != null &&
        _customSecondary != null) {
      final colorScheme = ColorScheme(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primary: _customPrimary!,
        onPrimary: Colors.white,
        secondary: _customSecondary!,
        onSecondary: Colors.black,
        surface: _isDarkMode ? const Color(0xFF121212) : Colors.white,
        onSurface: _isDarkMode ? Colors.white : Colors.black,
        background: _isDarkMode
            ? const Color(0xFF000000)
            : const Color(0xFFF8F8F8),
        onBackground: _isDarkMode ? Colors.white : Colors.black,
        error: Colors.red,
        onError: Colors.white,
        tertiary: _customSecondary!, // 👈 boost visibility
        outline: _customSecondary!, // 👈 also use secondary for borders
        surfaceVariant: _isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        onSurfaceVariant: _isDarkMode ? Colors.white70 : Colors.black87,
        shadow: Colors.black,
        scrim: Colors.black54,
        inverseSurface: _isDarkMode ? Colors.white : Colors.black,
        onInverseSurface: _isDarkMode ? Colors.black : Colors.white,
        inversePrimary: _customPrimary!,
      );

      return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                colorScheme.secondary, // ✅ ensures secondary is visible
            foregroundColor: colorScheme.onSecondary,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
        ),
      );
    }

    // fallback to predefined themes
    final theme = appThemes.firstWhere(
      (t) => t.name == _selectedThemeName,
      orElse: () => appThemes.first,
    );
    return _isDarkMode ? theme.darkTheme : theme.lightTheme;
  }

  bool get isDarkMode => _isDarkMode;
  String get selectedThemeName => _selectedThemeName;
  String get timerName => _timerName;
  bool get isVibrationEnabled => _isVibrationEnabled;
  int get workSeconds => _workSeconds;
  int get breakSeconds => _breakSeconds;
  String get alarmSound => _alarmSound;

  Color? get customPrimary => _customPrimary;
  Color? get customSecondary => _customSecondary;

  SettingsProvider()
    : _selectedThemeName = 'Default',
      _isDarkMode = false,
      _timerName = 'Pomodoro Timer',
      _isVibrationEnabled = true,
      _workSeconds = 1500,
      _breakSeconds = 300,
      _alarmSound = 'audio/bell.wav' {
    _loadPreferences();
  }

  void setDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    _savePreferences();
    notifyListeners();
  }

  void setSelectedThemeName(String themeName) {
    _selectedThemeName = themeName;
    _savePreferences();
    notifyListeners();
  }

  /// Save & apply custom theme
  void setCustomTheme(Color primary, Color secondary) {
    _customPrimary = primary;
    _customSecondary = secondary;
    _selectedThemeName = "Custom"; // ✅ Switch active theme to custom
    _savePreferences();
    notifyListeners();
  }

  void setTimerName(String timerName) {
    _timerName = timerName;
    _savePreferences();
    notifyListeners();
  }

  void setVibration(bool isVibrationEnabled) {
    _isVibrationEnabled = isVibrationEnabled;
    _savePreferences();
    notifyListeners();
  }

  void setWorkSeconds(int workSeconds) {
    _workSeconds = workSeconds;
    _savePreferences();
    notifyListeners();
  }

  void setBreakSeconds(int breakSeconds) {
    _breakSeconds = breakSeconds;
    _savePreferences();
    notifyListeners();
  }

  void setAlarmSound(String alarmSound) {
    _alarmSound = alarmSound;
    _savePreferences();
    notifyListeners();
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedThemeName', _selectedThemeName);
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setString('timerName', _timerName);
    prefs.setBool('isVibrationEnabled', _isVibrationEnabled);
    prefs.setInt('workSeconds', _workSeconds);
    prefs.setInt('breakSeconds', _breakSeconds);
    prefs.setString('alarmSound', _alarmSound);

    // Save custom theme colors
    if (_customPrimary != null && _customSecondary != null) {
      prefs.setInt('customPrimary', _customPrimary!.value);
      prefs.setInt('customSecondary', _customSecondary!.value);
    }
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedThemeName = prefs.getString('selectedThemeName') ?? 'Default';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _timerName = prefs.getString('timerName') ?? 'Pomodoro Timer';
    _isVibrationEnabled = prefs.getBool('isVibrationEnabled') ?? true;
    _workSeconds = prefs.getInt('workSeconds') ?? 1500;
    _breakSeconds = prefs.getInt('breakSeconds') ?? 300;
    _alarmSound = prefs.getString('alarmSound') ?? 'audio/bell.wav';

    // Load custom theme colors if available
    final p = prefs.getInt('customPrimary');
    final s = prefs.getInt('customSecondary');
    if (p != null && s != null) {
      _customPrimary = Color(p);
      _customSecondary = Color(s);
    }

    notifyListeners();
  }
}
