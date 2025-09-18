import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider with ChangeNotifier {
  static const String _sessionsKey = 'pomodoro_sessions';
  static const String _dailyGoalKey = 'daily_goal';
  static const String _goalSetDateKey = 'goal_set_date';

  List<DateTime> _sessions = [];
  int _dailyGoal = 0;
  DateTime? _goalSetDate;

  List<DateTime> get sessions => _sessions;
  int get dailyGoal => _dailyGoal;

  ProgressProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionStrings = prefs.getStringList(_sessionsKey) ?? [];
    _sessions = sessionStrings.map((s) => DateTime.parse(s)).toList();

    _dailyGoal = prefs.getInt(_dailyGoalKey) ?? 0;
    final goalSetDateString = prefs.getString(_goalSetDateKey);
    if (goalSetDateString != null) {
      _goalSetDate = DateTime.parse(goalSetDateString);
      final today = DateTime.now();
      if (_goalSetDate!.year != today.year ||
          _goalSetDate!.month != today.month ||
          _goalSetDate!.day != today.day) {
        // Reset goal if it's from a previous day
        await setDailyGoal(0);
      }
    }

    notifyListeners();
  }

  Future<void> addSession() async {
    final now = DateTime.now();
    _sessions.add(now);
    final prefs = await SharedPreferences.getInstance();
    final sessionStrings = _sessions.map((dt) => dt.toIso8601String()).toList();
    await prefs.setStringList(_sessionsKey, sessionStrings);
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    _dailyGoal = goal;
    _goalSetDate = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyGoalKey, goal);
    await prefs.setString(_goalSetDateKey, _goalSetDate!.toIso8601String());
    notifyListeners();
  }

  int get dailyStreak {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return _sessions.where((s) => s.isAfter(todayStart)).length;
  }

  double get goalProgress {
    if (_dailyGoal == 0) {
      return 0.0;
    }
    return (dailyStreak / _dailyGoal).clamp(0.0, 1.0);
  }

  bool get isGoalCompleted {
    return _dailyGoal > 0 && dailyStreak >= _dailyGoal;
  }

  Map<int, int> get monthlyProgress {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final sessionsInMonth = _sessions.where((s) =>
        s.isAfter(monthStart) &&
        s.isBefore(monthEnd.add(const Duration(days: 1))));
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
