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

  ThemeData get themeData {
    final theme = appThemes.firstWhere((t) => t.name == _selectedThemeName, orElse: () => appThemes.first);
    return _isDarkMode ? theme.darkTheme : theme.lightTheme;
  }

  bool get isDarkMode => _isDarkMode;
  String get selectedThemeName => _selectedThemeName;
  String get timerName => _timerName;
  bool get isVibrationEnabled => _isVibrationEnabled;
  int get workSeconds => _workSeconds;
  int get breakSeconds => _breakSeconds;
  String get alarmSound => _alarmSound;

  SettingsProvider()
      : _selectedThemeName = 'Default',
        _isDarkMode = false,
        _timerName = 'Pomodoro Timer',
        _isVibrationEnabled = true,
        _workSeconds = 1500,
        _breakSeconds = 300,
        _alarmSound = 'alarm.wav' {
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
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedThemeName = prefs.getString('selectedThemeName') ?? 'Default';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _timerName = prefs.getString('timerName') ?? 'Pomodoro Timer';
    _isVibrationEnabled = prefs.getBool('isVibrationEnabled') ?? true;
    _workSeconds = prefs.getInt('workSeconds') ?? 1500;
    _breakSeconds = prefs.getInt('breakSeconds') ?? 300;
    _alarmSound = prefs.getString('alarmSound') ?? 'alarm.wav';
    notifyListeners();
  }
}
