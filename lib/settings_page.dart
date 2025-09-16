import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Choose Theme",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Grid of themes
              Expanded(
                child: GridView.builder(
                  itemCount: appThemes.length + 1, // +1 for custom picker
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    if (index == appThemes.length) {
                      // Custom Theme Picker card
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showCustomThemeDialog(context, settings);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.palette, size: 40),
                                SizedBox(height: 8),
                                Text("Custom"),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final theme = appThemes[index];
                    final colorScheme = theme.lightTheme.colorScheme;

                    return GestureDetector(
                      onTap: () {
                        settings.setSelectedThemeName(theme.name);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Theme sample (primary + secondary colors)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: colorScheme.secondary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              theme.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

void _showCustomThemeDialog(BuildContext context, SettingsProvider settings) {
  // Load previously saved custom colors, or fall back to defaults
  Color selectedPrimary = settings.customPrimary ?? Colors.blue;
  Color selectedSecondary = settings.customSecondary ?? Colors.amber;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Custom Theme"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary picker
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pick Primary Color",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlockPicker(
                    pickerColor: selectedPrimary,
                    onColorChanged: (color) {
                      setState(() => selectedPrimary = color);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Secondary picker
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pick Secondary Color",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlockPicker(
                    pickerColor: selectedSecondary,
                    onColorChanged: (color) {
                      setState(() => selectedSecondary = color);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save custom theme to provider & preferences
                  settings.setCustomTheme(selectedPrimary, selectedSecondary);
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
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
                builder: (context) {
                  final theme = Theme.of(context).colorScheme;
                  return Container(
                    height: 300,
                    color: theme.surface, // ✅ background adjusts with theme
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        brightness: Theme.of(context).brightness,
                        primaryColor:
                            theme.onSurface, // ✅ digits & controls color
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: theme.onSurface, // ✅ picker digits
                            fontSize: 20,
                          ),
                        ),
                      ),
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
                            child: Text(
                              'Save',
                              style: TextStyle(color: theme.primary),
                            ),
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
                builder: (context) {
                  final theme = Theme.of(context).colorScheme;

                  return Container(
                    height: 300,
                    color: theme.surface,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        brightness: Theme.of(context).brightness,
                        primaryColor:
                            theme.onSurface, // ✅ digits & controls color
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: theme.onSurface, // ✅ picker digits
                            fontSize: 20,
                          ),
                        ),
                      ),
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
                            child: Text(
                              'Save',
                              style: TextStyle(color: theme.primary),
                            ),
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
