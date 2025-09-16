import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeData _themeData;
  bool _isVibrationEnabled;
  int _workSeconds;
  int _breakSeconds;
  String _alarmSound;

  ThemeData get themeData => _themeData;
  bool get isVibrationEnabled => _isVibrationEnabled;
  int get workSeconds => _workSeconds;
  int get breakSeconds => _breakSeconds;
  String get alarmSound => _alarmSound;

  SettingsProvider()
      : _themeData = ThemeData.light(),
        _isVibrationEnabled = true,
        _workSeconds = 1500,
        _breakSeconds = 300,
        _alarmSound = 'alarm.wav' {
    _loadPreferences();
  }

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
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
    prefs.setBool('isDarkMode', _themeData.brightness == Brightness.dark);
    prefs.setBool('isVibrationEnabled', _isVibrationEnabled);
    prefs.setInt('workSeconds', _workSeconds);
    prefs.setInt('breakSeconds', _breakSeconds);
    prefs.setString('alarmSound', _alarmSound);
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? ThemeData.dark() : ThemeData.light();
    _isVibrationEnabled = prefs.getBool('isVibrationEnabled') ?? true;
    _workSeconds = prefs.getInt('workSeconds') ?? 1500;
    _breakSeconds = prefs.getInt('breakSeconds') ?? 300;
    _alarmSound = prefs.getString('alarmSound') ?? 'alarm.wav';
    notifyListeners();
  }
}
