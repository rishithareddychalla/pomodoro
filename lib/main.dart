// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:pomodoo/progress_provider.dart';
// import 'package:pomodoo/timer_screen.dart';

// import 'package:provider/provider.dart';
// import 'package:vibration/vibration.dart';
// import 'settings_page.dart';
// import 'settings_provider.dart';

// void main() => runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => SettingsProvider()),
//           ChangeNotifierProvider(create: (context) => ProgressProvider()),
//         ],
//         child: const MyApp(),
//       ),
//     );

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: Provider.of<SettingsProvider>(context).themeData,
//       home: const PomodoroScreen(),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:pomodoo/progress_page.dart';
import 'package:pomodoo/progress_provider.dart';
import 'package:pomodoo/timer_screen.dart';
import 'package:pomodoo/settings_page.dart';
import 'package:pomodoo/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of pages to navigate between
  static const List<Widget> _pages = <Widget>[
    PomodoroScreen(),
    ProgressPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all icons are always visible
      ),
    );
  }
}