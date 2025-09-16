import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'themes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _timerNameController;

  @override
  void initState() {
    super.initState();
    _timerNameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timerNameController.text = Provider.of<SettingsProvider>(
      context,
      listen: false,
    ).timerName;
  }

  @override
  void dispose() {
    _timerNameController.dispose();
    super.dispose();
  }

  void _showThemeBottomSheet(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: ListView.builder(
            itemCount: appThemes.length,
            itemBuilder: (context, index) {
              final theme = appThemes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.lightTheme.primaryColor,
                ),
                title: Text(theme.name),
                onTap: () {
                  settings.setSelectedThemeName(theme.name);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settings.isDarkMode,
            onChanged: (value) {
              settings.setDarkMode(value);
            },
            activeColor: Theme.of(context).colorScheme.onPrimary, // thumb
            activeTrackColor: Theme.of(context).colorScheme.primary, // track
            inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
            inactiveTrackColor: Theme.of(context).colorScheme.surface,
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(settings.selectedThemeName),
            onTap: () {
              _showThemeBottomSheet(context);
            },
          ),
          ListTile(
            title: const Text('Timer Name'),
            subtitle: TextFormField(
              controller: _timerNameController,
              onFieldSubmitted: (value) {
                settings.setTimerName(value);
              },
            ),
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
                  color: Colors.blue,
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
                      ),
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
                  color: Colors.black,
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
                      ),
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
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'alarm.wav', child: Text('Alarm')),
                DropdownMenuItem(value: 'digital.wav', child: Text('Digital')),
                DropdownMenuItem(value: 'classic.wav', child: Text('Classic')),
                DropdownMenuItem(
                  value: 'new_alarm.wav',
                  child: Text('New Alarm'),
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
