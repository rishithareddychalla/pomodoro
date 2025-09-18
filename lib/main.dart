import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:pomodoro/progress_provider.dart';
import 'package:pomodoro/timer_screen.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'settings_page.dart';
import 'settings_provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsProvider()),
          ChangeNotifierProvider(create: (context) => ProgressProvider()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<SettingsProvider>(context).themeData,
      home: const PomodoroScreen(),
    );
  }
}
