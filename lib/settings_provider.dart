import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeData _themeData;
  bool _isVibrationEnabled;
  int _workSeconds;
  int _breakSeconds;
  String _alarmSound;
  String _timerName;
  String _selectedTheme;

  ThemeData get themeData => _themeData;
  bool get isVibrationEnabled => _isVibrationEnabled;
  int get workSeconds => _workSeconds;
  int get breakSeconds => _breakSeconds;
  String get alarmSound => _alarmSound;
  String get timerName => _timerName;
  String get selectedTheme => _selectedTheme;

  static final Map<String, ThemeData> _lightThemes = {
    'Default': ThemeData.light(),
    'Ocean': ThemeData(primarySwatch: Colors.blue),
    'Forest': ThemeData(primarySwatch: Colors.green),
  };

  static final Map<String, ThemeData> _darkThemes = {
    'Default': ThemeData.dark(),
    'Ocean': ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[900]),
    'Forest': ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[900]),
  };

  SettingsProvider()
      : _themeData = _lightThemes['Default']!,
        _isVibrationEnabled = true,
        _workSeconds = 1500,
        _breakSeconds = 300,
        _alarmSound = 'alarm.wav',
        _timerName = 'Pomodoro Timer',
        _selectedTheme = 'Default' {
    _loadPreferences();
  }

  void setTheme(String themeName, {bool? isDarkMode}) {
    bool darkMode = isDarkMode ?? _themeData.brightness == Brightness.dark;
    _selectedTheme = themeName;
    _themeData =
        darkMode ? _darkThemes[themeName]! : _lightThemes[themeName]!;
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

  void setTimerName(String timerName) {
    _timerName = timerName;
    _savePreferences();
    notifyListeners();
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData.brightness == Brightness.dark);
    prefs.setBool('isVibrationEnabled', _isVibrationEnabled);
    prefs.setInt('workSeconds', _workSeconds);
    prefs.setInt('breakSeconds', _breakSeconds);
    prefs.setString('alarmSound', _alarmSound);
    prefs.setString('timerName', _timerName);
    prefs.setString('selectedTheme', _selectedTheme);
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _selectedTheme = prefs.getString('selectedTheme') ?? 'Default';
    _themeData =
        isDarkMode ? _darkThemes[_selectedTheme]! : _lightThemes[_selectedTheme]!;
    _isVibrationEnabled = prefs.getBool('isVibrationEnabled') ?? true;
    _workSeconds = prefs.getInt('workSeconds') ?? 1500;
    _breakSeconds = prefs.getInt('breakSeconds') ?? 300;
    _alarmSound = prefs.getString('alarmSound') ?? 'alarm.wav';
    _timerName = prefs.getString('timerName') ?? 'Pomodoro Timer';
    notifyListeners();
  }
}
