import 'package:flutter/material.dart';
import 'package:pomodoo/home_screen.dart';
import 'package:pomodoo/progress_provider.dart';
import 'package:provider/provider.dart';
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
      home: const HomeScreen(),
    );
  }
}
