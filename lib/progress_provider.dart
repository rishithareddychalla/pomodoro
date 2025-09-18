import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProgressProvider with ChangeNotifier {
  static const String _sessionsKey = 'pomodoro_sessions';
  static const String _goalKey = 'daily_goal';
  static const String _goalDateKey = 'goal_date';

  List<DateTime> _sessions = [];
  int _dailyGoal = 0;
  String _goalDate = '';

  List<DateTime> get sessions => _sessions;
  int get dailyGoal => _dailyGoal;
  String get goalDate => _goalDate;

  ProgressProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    // Load sessions
    final sessionStrings = prefs.getStringList(_sessionsKey) ?? [];
    _sessions = sessionStrings.map((s) => DateTime.parse(s)).toList();

    // Load goal
    _dailyGoal = prefs.getInt(_goalKey) ?? 0;
    _goalDate = prefs.getString(_goalDateKey) ?? '';

    // Check if goal needs reset
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (_goalDate != today) {
      _dailyGoal = 0;
      await prefs.setInt(_goalKey, 0);
    }

    notifyListeners();
  }

  Future<void> addSession() async {
    final now = DateTime.now();
    // Check if the date has changed to reset daily progress
    final today = DateFormat('yyyy-MM-dd').format(now);
    if (_goalDate != today) {
      _goalDate = today;
      _dailyGoal = 0; // Reset goal if day changes
    }

    _sessions.add(now);
    final prefs = await SharedPreferences.getInstance();
    final sessionStrings = _sessions.map((dt) => dt.toIso8601String()).toList();
    await prefs.setStringList(_sessionsKey, sessionStrings);
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    _dailyGoal = goal;
    _goalDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setInt(_goalKey, _dailyGoal);
    await prefs.setString(_goalDateKey, _goalDate);
    notifyListeners();
  }

  Future<void> resetDailyGoal() async {
    await setDailyGoal(0);
  }

  int get dailySessions {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return _sessions.where((s) => s.isAfter(todayStart)).length;
  }

  // backward compatibility
  int get dailyStreak => dailySessions;

  Map<int, int> get monthlyProgress {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final sessionsInMonth = _sessions.where((s) => s.isAfter(monthStart) && s.isBefore(monthEnd.add(const Duration(days: 1))));
    final Map<int, int> progress = {};
    for (var session in sessionsInMonth) {
      progress[session.day] = (progress[session.day] ?? 0) + 1;
    }
    return progress;
  }

  int get continuousStreak {
    if (_sessions.isEmpty) {
      return 0;
    }

    final uniqueDays =
        _sessions.map((s) => DateTime(s.year, s.month, s.day)).toSet();

    var streak = 0;
    var day =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (uniqueDays.contains(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    } else {
      day = day.subtract(const Duration(days: 1));
      if (!uniqueDays.contains(day)) {
        return 0;
      }
    }

    while (uniqueDays.contains(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
