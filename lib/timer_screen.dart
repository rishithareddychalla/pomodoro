import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:pomodoo/progress_page.dart';
import 'package:pomodoo/progress_provider.dart';
import 'package:pomodoo/settings_page.dart';
import 'package:pomodoo/settings_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

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
    _seconds = Provider.of<SettingsProvider>(
      context,
      listen: false,
    ).workSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
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
    final progressProvider = Provider.of<ProgressProvider>(
      context,
      listen: false,
    );
    if (_isWorkMode) {
      progressProvider.addSession().then((_) {
        if (progressProvider.dailySessions == progressProvider.dailyGoal &&
            progressProvider.dailyGoal > 0) {
          _showGoalCompletedDialog();
        }
      });
    }
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _player.stop();
    setState(() {
      _isAlarmPlaying = false;
      _isWorkMode = !_isWorkMode;
      _seconds = _isWorkMode ? settings.workSeconds : settings.breakSeconds;
    });
    _startPauseTimer();
  }

  void _showGoalCompletedDialog() {
    final GlobalKey repaintKey = GlobalKey();
    final progressProvider = Provider.of<ProgressProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: repaintKey,
              child: _buildShareableCard(
                context,
                'Goal Completed!',
                progressProvider.dailyGoal,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () async {
                    final boundary =
                        repaintKey.currentContext?.findRenderObject()
                            as RenderRepaintBoundary?;
                    if (boundary != null) {
                      final image = await boundary.toImage(pixelRatio: 3.0);
                      final byteData = await image.toByteData(
                        format: ui.ImageByteFormat.png,
                      );
                      if (byteData != null) {
                        final pngBytes = byteData.buffer.asUint8List();
                        final xFile = XFile.fromData(
                          pngBytes,
                          mimeType: 'image/png',
                          name: "goal_completed.png",
                        );
                        await Share.shareXFiles([
                          xFile,
                        ], text: "I completed my daily Pomodoro goal!");
                      }
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    progressProvider.resetDailyGoal();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset Goal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareableCard(BuildContext context, String title, int streak) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: theme.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.primaryContainer,
            child: const Icon(
              Icons.check_circle_outline,
              size: 30,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$streak sessions ✅',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Great job! Keep it up! 🚀",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.timerName),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProgressPage()),
              );
            },
          ),
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
                    value:
                        _seconds /
                        (_isWorkMode
                            ? settings.workSeconds
                            : settings.breakSeconds),
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(
                      _isWorkMode ? theme.primary : theme.secondary,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                      ? theme.primary
                      : theme.secondary,
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.light
                              ? theme.primary
                              : theme.secondary,
                          foregroundColor:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text(_isRunning ? 'Pause' : 'Start'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _resetTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.light
                              ? theme.primary
                              : theme.secondary,
                          foregroundColor:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                        ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                          ? theme.primary
                          : theme.secondary,
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                    ),
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
