import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _workSeconds = 1500;
  int _breakSeconds = 300;
  int _seconds = 1500; // 25 minutes in seconds
  bool _isRunning = false;
  bool _isWorkMode = true; // Work (25 min) or Break (5 min)
  Timer? _timer;
  final _player = AudioPlayer();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Timer Durations'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Work'),
                subtitle: Text('${_workSeconds ~/ 60} minutes'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: _workSeconds ~/ 3600,
                        minute: (_workSeconds % 3600) ~/ 60),
                  );
                  if (time != null) {
                    setState(() {
                      _workSeconds = time.hour * 3600 + time.minute * 60;
                      if (!_isRunning && _isWorkMode) {
                        _seconds = _workSeconds;
                      }
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Break'),
                subtitle: Text('${_breakSeconds ~/ 60} minutes'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: _breakSeconds ~/ 3600,
                        minute: (_breakSeconds % 3600) ~/ 60),
                  );
                  if (time != null) {
                    setState(() {
                      _breakSeconds = time.hour * 3600 + time.minute * 60;
                      if (!_isRunning && !_isWorkMode) {
                        _seconds = _breakSeconds;
                      }
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAlarmDialog() {
    _player.play(AssetSource('alarm.wav'));
    Vibration.vibrate(duration: 1000);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Time\'s up!'),
          content: Text(_isWorkMode ? 'Time for a break!' : 'Time to work!'),
          actions: [
            TextButton(
              onPressed: () {
                _player.stop();
                Navigator.pop(context);
                setState(() {
                  _isRunning = false;
                  _isWorkMode = !_isWorkMode;
                  _seconds = _isWorkMode ? _workSeconds : _breakSeconds;
                });
              },
              child: const Text('Stop Alarm'),
            ),
          ],
        );
      },
    ).then((_) {
      _player.stop();
    });
  }

  void _startPauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          _timer?.cancel();
          _showAlarmDialog();
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _seconds = _isWorkMode ? _workSeconds : _breakSeconds;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Display
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _seconds /
                        (_isWorkMode ? _workSeconds : _breakSeconds),
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _isWorkMode ? Colors.blue : Colors.green,
                    ),
                  ),
                ),
                Text(
                  _formatTime(_seconds),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _isWorkMode ? 'Work' : 'Break',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startPauseTimer,
                  child: Text(_isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                setState(() {
                  _isRunning = false;
                  _isWorkMode = !_isWorkMode;
                  _seconds = _isWorkMode ? _workSeconds : _breakSeconds;
                });
              },
              child: Text('Switch to ${_isWorkMode ? 'Break' : 'Work'}'),
            ),
          ],
        ),
      ),
    );
  }
}
