// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';
// import 'package:pomodoo/progress_provider.dart';
// import 'package:pomodoo/settings_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vibration/vibration.dart';

// class PomodoroScreen extends StatefulWidget {
//   const PomodoroScreen({super.key});

//   @override
//   _PomodoroScreenState createState() => _PomodoroScreenState();
// }

// class _PomodoroScreenState extends State<PomodoroScreen> {
//   int _seconds = 1500;
//   bool _isRunning = false;
//   bool _isWorkMode = true;
//   bool _isAlarmPlaying = false;
//   Timer? _timer;
//   final _player = AudioPlayer();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _seconds = Provider.of<SettingsProvider>(
//       context,
//       listen: false,
//     ).workSeconds;
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _player.dispose();
//     super.dispose();
//   }

//   void _startPauseTimer() {
//     final settings = Provider.of<SettingsProvider>(context, listen: false);
//     if (_isRunning) {
//       _timer?.cancel();
//     } else {
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (_seconds > 0) {
//           setState(() => _seconds--);
//         } else {
//           _timer?.cancel();
//           setState(() {
//             _isRunning = false;
//             _isAlarmPlaying = true;
//           });
//           if (settings.alarmSound != 'none') {
//             _player.play(AssetSource(settings.alarmSound));
//           }
//           if (settings.isVibrationEnabled) {
//             Vibration.vibrate();
//           }
//         }
//       });
//     }
//     setState(() => _isRunning = !_isRunning);
//   }

//   void _resetTimer() {
//     final settings = Provider.of<SettingsProvider>(context, listen: false);
//     _timer?.cancel();
//     setState(() {
//       _isRunning = false;
//       _seconds = _isWorkMode ? settings.workSeconds : settings.breakSeconds;
//     });
//   }

//   void _pauseAlarmAndStartNextTimer() {
//     final progressProvider = Provider.of<ProgressProvider>(
//       context,
//       listen: false,
//     );
//     if (_isWorkMode) {
//       progressProvider.addSession().then((_) {
//         if (progressProvider.dailySessions == progressProvider.dailyGoal &&
//             progressProvider.dailyGoal > 0) {
//           _showGoalCompletedDialog();
//         }
//       });
//     }
//     final settings = Provider.of<SettingsProvider>(context, listen: false);
//     _player.stop();
//     setState(() {
//       _isAlarmPlaying = false;
//       _isWorkMode = !_isWorkMode;
//       _seconds = _isWorkMode ? settings.workSeconds : settings.breakSeconds;
//     });
//     _startPauseTimer();
//   }

//   void _showGoalCompletedDialog() {
//     final GlobalKey repaintKey = GlobalKey();
//     final progressProvider = Provider.of<ProgressProvider>(
//       context,
//       listen: false,
//     );

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         contentPadding: const EdgeInsets.all(16),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             RepaintBoundary(
//               key: repaintKey,
//               child: _buildShareableCard(
//                 context,
//                 'Goal Completed!',
//                 progressProvider.dailyGoal,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.share),
//                   label: const Text("Share"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Theme.of(context).brightness == Brightness.light
//                         ? Theme.of(context).colorScheme.primary
//                         : Theme.of(context).colorScheme.secondary,
//                     foregroundColor:
//                         Theme.of(context).brightness == Brightness.light
//                         ? Colors.white
//                         : Colors.black,
//                   ),
//                   onPressed: () async {
//                     final boundary =
//                         repaintKey.currentContext?.findRenderObject()
//                             as RenderRepaintBoundary?;
//                     if (boundary != null) {
//                       final image = await boundary.toImage(pixelRatio: 3.0);
//                       final byteData = await image.toByteData(
//                         format: ui.ImageByteFormat.png,
//                       );
//                       if (byteData != null) {
//                         final pngBytes = byteData.buffer.asUint8List();
//                         final xFile = XFile.fromData(
//                           pngBytes,
//                           mimeType: 'image/png',
//                           name: "goal_completed.png",
//                         );
//                         await Share.shareXFiles([
//                           xFile,
//                         ], text: "I completed my daily Pomodoro goal!");
//                       }
//                     }
//                   },
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     progressProvider.resetDailyGoal();
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Reset Goal'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShareableCard(BuildContext context, String title, int streak) {
//     final theme = Theme.of(context).colorScheme;

//     return Container(
//       width: 280,
//       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
//       decoration: BoxDecoration(
//         color: theme.surface,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//         border: Border.all(color: theme.primary.withOpacity(0.3), width: 1.5),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: theme.primaryContainer,
//             child: const Icon(
//               Icons.check_circle_outline,
//               size: 30,
//               color: Colors.green,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: theme.onSurface,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             '$streak sessions ✅',
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//               color: theme.primary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             "Great job! Keep it up! 🚀",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settings = Provider.of<SettingsProvider>(context);
//     final theme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(title: Text(settings.timerName)),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   width: 200,
//                   height: 200,
//                   child: CircularProgressIndicator(
//                     value:
//                         _seconds /
//                         (_isWorkMode
//                             ? settings.workSeconds
//                             : settings.breakSeconds),
//                     strokeWidth: 10,
//                     backgroundColor: Colors.grey[300],
//                     valueColor: AlwaysStoppedAnimation(
//                       _isWorkMode ? theme.primary : theme.secondary,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   _formatTime(_seconds),
//                   style: const TextStyle(
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _isWorkMode ? 'Work' : 'Break',
//               style: const TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 20),
//             if (_isAlarmPlaying)
//               ElevatedButton(
//                 onPressed: _pauseAlarmAndStartNextTimer,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       Theme.of(context).brightness == Brightness.light
//                       ? theme.primary
//                       : theme.secondary,
//                   foregroundColor:
//                       Theme.of(context).brightness == Brightness.light
//                       ? Colors.white
//                       : Colors.black,
//                 ),
//                 child: const Text('Pause'),
//               )
//             else
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: _startPauseTimer,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Theme.of(context).brightness == Brightness.light
//                               ? theme.primary
//                               : theme.secondary,
//                           foregroundColor:
//                               Theme.of(context).brightness == Brightness.light
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                         child: Text(_isRunning ? 'Pause' : 'Start'),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: _resetTimer,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Theme.of(context).brightness == Brightness.light
//                               ? theme.primary
//                               : theme.secondary,
//                           foregroundColor:
//                               Theme.of(context).brightness == Brightness.light
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                         child: const Text('Reset'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       _timer?.cancel();
//                       setState(() {
//                         _isRunning = false;
//                         _isWorkMode = !_isWorkMode;
//                         _seconds = _isWorkMode
//                             ? settings.workSeconds
//                             : settings.breakSeconds;
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           Theme.of(context).brightness == Brightness.light
//                           ? theme.primary
//                           : theme.secondary,
//                       foregroundColor:
//                           Theme.of(context).brightness == Brightness.light
//                           ? Colors.white
//                           : Colors.black,
//                     ),
//                     child: Text('Switch to ${_isWorkMode ? 'Break' : 'Work'}'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:pomodoo/progress_provider.dart';
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

class _PomodoroScreenState extends State<PomodoroScreen> with SingleTickerProviderStateMixin {
  int _seconds = 1500;
  bool _isRunning = false;
  bool _isWorkMode = true;
  bool _isAlarmPlaying = false;
  Timer? _timer;
  final _player = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

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
    _animationController.dispose();
    super.dispose();
  }

  void _startPauseTimer() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (_isRunning) {
      _timer?.cancel();
      _animationController.reverse();
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
      _animationController.forward();
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _resetTimer() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _timer?.cancel();
    _animationController.reverse();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: repaintKey,
              child: _buildShareableCard(
                context,
                'Goal Completed! 🎉',
                progressProvider.dailyGoal,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    elevation: 2,
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
                        ], text: "I completed my daily Pomodoro goal! 🎉");
                      }
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    progressProvider.resetDailyGoal();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Reset Goal',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
      width: 300,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.surface,
            theme.surfaceVariant.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: theme.primary.withOpacity(0.4), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: theme.primaryContainer,
            child: const Icon(
              Icons.check_circle_rounded,
              size: 36,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$streak sessions ✅',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "You're killing it! 🚀",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.onSurfaceVariant,
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
        title: Text(
          settings.timerName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: theme.surface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.surface,
              theme.background.withOpacity(0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              theme.primary.withOpacity(0.1),
                              theme.background,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: _seconds /
                              (_isWorkMode
                                  ? settings.workSeconds
                                  : settings.breakSeconds),
                          strokeWidth: 12,
                          backgroundColor: theme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation(
                            _isWorkMode ? theme.primary : theme.secondary,
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(_seconds),
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: theme.onSurface,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _isWorkMode ? 'Work' : 'Break',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: theme.onSurface,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_isAlarmPlaying)
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: ElevatedButton(
                        onPressed: _pauseAlarmAndStartNextTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: theme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Pause & Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: ElevatedButton(
                                onPressed: _startPauseTimer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primary,
                                  foregroundColor: theme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  elevation: 3,
                                ),
                                child: Text(
                                  _isRunning ? 'Pause' : 'Start',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _resetTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.secondary,
                                foregroundColor: theme.onSecondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                elevation: 3,
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _timer?.cancel();
                            _animationController.reverse();
                            setState(() {
                              _isRunning = false;
                              _isWorkMode = !_isWorkMode;
                              _seconds = _isWorkMode
                                  ? settings.workSeconds
                                  : settings.breakSeconds;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.surfaceVariant,
                            foregroundColor: theme.onSurfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            elevation: 2,
                          ),
                          child: Text(
                            'Switch to ${_isWorkMode ? 'Break' : 'Work'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}