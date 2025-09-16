import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settings.themeData.brightness == Brightness.dark,
            onChanged: (value) {
              settings.setTheme(value ? ThemeData.dark() : ThemeData.light());
            },
          ),
          SwitchListTile(
            title: const Text('Enable Vibration'),
            value: settings.isVibrationEnabled,
            onChanged: (value) {
              settings.setVibration(value);
            },
          ),
          ListTile(
            title: const Text('Work Duration'),
            trailing: Text('${settings.workSeconds ~/ 60} minutes'),
            onTap: () {
              Duration newDuration = Duration(seconds: settings.workSeconds);
              showCupertinoModalPopup<void>(
                context: context,
                builder: (context) => Container(
                  height: 300,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.ms,
                          initialTimerDuration: newDuration,
                          onTimerDurationChanged: (duration) {
                            newDuration = duration;
                          },
                        ),
                      ),
                      CupertinoButton(
                        child: const Text('Save'),
                        onPressed: () {
                          settings.setWorkSeconds(newDuration.inSeconds);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Break Duration'),
            trailing: Text('${settings.breakSeconds ~/ 60} minutes'),
            onTap: () {
              Duration newDuration = Duration(seconds: settings.breakSeconds);
              showCupertinoModalPopup<void>(
                context: context,
                builder: (context) => Container(
                  height: 300,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.ms,
                          initialTimerDuration: newDuration,
                          onTimerDurationChanged: (duration) {
                            newDuration = duration;
                          },
                        ),
                      ),
                      CupertinoButton(
                        child: const Text('Save'),
                        onPressed: () {
                          settings.setBreakSeconds(newDuration.inSeconds);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Alarm Sound'),
            trailing: DropdownButton<String>(
              value: settings.alarmSound,
              items: const [
                DropdownMenuItem(
                  value: 'none',
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: 'alarm.wav',
                  child: Text('Alarm'),
                ),
                DropdownMenuItem(
                  value: 'digital.wav',
                  child: Text('Digital'),
                ),
                DropdownMenuItem(
                  value: 'classic.wav',
                  child: Text('Classic'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.setAlarmSound(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
