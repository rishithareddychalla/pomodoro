import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pomodoro/progress_provider.dart';
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: settings.selectedThemeName == theme.name
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
              content: SizedBox(
                width: double.maxFinite,
                height: 450, // fixed height so overall content scrolls
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pick Primary Color",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      BlockPicker(
                        pickerColor: selectedPrimary,
                        onColorChanged: (color) =>
                            setState(() => selectedPrimary = color),
                        availableColors: aestheticColors,
                        layoutBuilder: (context, colors, child) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: colors
                                .map(
                                  (c) => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: child(c),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Pick Secondary Color",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      BlockPicker(
                        pickerColor: selectedSecondary,
                        onColorChanged: (color) =>
                            setState(() => selectedSecondary = color),
                        availableColors: aestheticColors,
                        layoutBuilder: (context, colors, child) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: colors
                                .map(
                                  (c) => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: child(c),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
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
          ListTile(
            title: const Text('Daily Goal'),
            subtitle: Text(
              '${Provider.of<ProgressProvider>(context).dailyGoal} sessions',
            ),
            onTap: () => _showGoalDialog(context),
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
            trailing: Text('${settings.workSeconds ~/ 60} min'),
            onTap: () {
              _showDurationPicker(
                context,
                "Work Duration",
                Duration(seconds: settings.workSeconds),
                (newDuration) => settings.setWorkSeconds(newDuration.inSeconds),
              );
            },
          ),
          ListTile(
            title: const Text('Break Duration'),
            trailing: Text('${settings.breakSeconds ~/ 60} min'),
            onTap: () {
              _showDurationPicker(
                context,
                "Break Duration",
                Duration(seconds: settings.breakSeconds),
                (newDuration) =>
                    settings.setBreakSeconds(newDuration.inSeconds),
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

  void _showGoalDialog(BuildContext context) {
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
    final goalController =
        TextEditingController(text: progressProvider.dailyGoal.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Daily Goal'),
        content: TextField(
          controller: goalController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of sessions',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final goal = int.tryParse(goalController.text) ?? 0;
              progressProvider.setDailyGoal(goal);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

void _showDurationPicker(
  BuildContext context,
  String title,
  Duration initialDuration,
  Function(Duration) onSave,
) {
  Duration newDuration = initialDuration;
  final theme = Theme.of(context).colorScheme;

  showCupertinoModalPopup<void>(
    context: context,
    builder: (context) {
      return Container(
        height: 320,
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Theme.of(context).brightness,
            primaryColor: theme.onSurface,
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                color: theme.onSurface,
                fontSize: 20,
              ),
            ),
          ),
          child: Column(
            children: [
              // 🔹 Top Action Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.onSurface.withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: theme.primary),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.onSurface,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Save',
                        style: TextStyle(color: theme.primary),
                      ),
                      onPressed: () {
                        onSave(newDuration);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 0.6), // thin separator
              // 🔹 Timer Picker
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.ms,
                  initialTimerDuration: initialDuration,
                  onTimerDurationChanged: (duration) {
                    newDuration = duration;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
