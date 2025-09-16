import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'settings_page.dart';
import 'settings_provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => SettingsProvider(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<SettingsProvider>(context).themeData,
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
  int _seconds = 1500;
  bool _isRunning = false;
  bool _isWorkMode = true;
  bool _isAlarmPlaying = false;
  Timer? _timer;
  final _player = AudioPlayer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _seconds = Provider.of<SettingsProvider>(context, listen: false).workSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPauseTimer() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _isAlarmPlaying = true;
          });
          if (settings.alarmSound != 'none') {
            _player.play(AssetSource(settings.alarmSound));
          }
          if (settings.isVibrationEnabled) {
            Vibration.vibrate();
          }
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _resetTimer() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _seconds = _isWorkMode ? settings.workSeconds : settings.breakSeconds;
    });
  }

  void _pauseAlarmAndStartNextTimer() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _player.stop();
    setState(() {
      _isAlarmPlaying = false;
      _isWorkMode = !_isWorkMode;
      _seconds = _isWorkMode ? settings.workSeconds : settings.breakSeconds;
    });
    _startPauseTimer();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _seconds /
                        (_isWorkMode
                            ? settings.workSeconds
                            : settings.breakSeconds),
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
            if (_isAlarmPlaying)
              ElevatedButton(
                onPressed: _pauseAlarmAndStartNextTimer,
                child: const Text('Pause'),
              )
            else
              Column(
                children: [
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
                        _seconds = _isWorkMode
                            ? settings.workSeconds
                            : settings.breakSeconds;
                      });
                    },
                    child: Text('Switch to ${_isWorkMode ? 'Break' : 'Work'}'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
