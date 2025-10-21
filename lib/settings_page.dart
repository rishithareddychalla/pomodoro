// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:pomodoo/progress_provider.dart';

// import 'package:provider/provider.dart';
// import 'settings_provider.dart';
// import 'themes.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   late TextEditingController _timerNameController;

//   @override
//   void initState() {
//     super.initState();
//     _timerNameController = TextEditingController();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _timerNameController.text = Provider.of<SettingsProvider>(
//       context,
//       listen: false,
//     ).timerName;
//   }

//   @override
//   void dispose() {
//     _timerNameController.dispose();
//     super.dispose();
//   }

//   void _showThemeBottomSheet(BuildContext context) {
//     final settings = Provider.of<SettingsProvider>(context, listen: false);

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Theme.of(context).brightness == Brightness.light
//           ? Colors.white
//           : Colors.black,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Theme.of(
//                       context,
//                     ).colorScheme.onSurface.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const Text(
//                 "Choose Theme",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),

//               // Grid of themes
//               Expanded(
//                 child: GridView.builder(
//                   itemCount: appThemes.length + 1, // +1 for custom picker
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.9,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                   ),
//                   itemBuilder: (context, index) {
//                     if (index == appThemes.length) {
//                       // Custom Theme Picker card
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showCustomThemeDialog(context, settings);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.surfaceVariant,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: Theme.of(context).colorScheme.primary,
//                               width: 2,
//                             ),
//                           ),
//                           child: const Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.palette, size: 40),
//                                 SizedBox(height: 8),
//                                 Text("Custom"),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }

//                     final theme = appThemes[index];
//                     final colorScheme = theme.lightTheme.colorScheme;

//                     return GestureDetector(
//                       onTap: () {
//                         settings.setSelectedThemeName(theme.name);
//                         Navigator.pop(context);
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         decoration: BoxDecoration(
//                           color: colorScheme.surface,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: settings.selectedThemeName == theme.name
//                                 ? colorScheme.primary
//                                 : Colors.transparent,
//                             width: 2,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.08),
//                               blurRadius: 6,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CircleAvatar(
//                                   radius: 14,
//                                   backgroundColor: colorScheme.primary,
//                                 ),
//                                 const SizedBox(width: 10),
//                                 CircleAvatar(
//                                   radius: 14,
//                                   backgroundColor: colorScheme.secondary,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               theme.name,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showCustomThemeDialog(BuildContext context, SettingsProvider settings) {
//     Color selectedPrimary = settings.customPrimary ?? Colors.blue;
//     Color selectedSecondary = settings.customSecondary ?? Colors.amber;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: const Text("Custom Theme"),
//               content: SizedBox(
//                 width: double.maxFinite,
//                 height: 450, // fixed height so overall content scrolls
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Pick Primary Color",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       BlockPicker(
//                         pickerColor: selectedPrimary,
//                         onColorChanged: (color) =>
//                             setState(() => selectedPrimary = color),
//                         availableColors: aestheticColors,
//                         layoutBuilder: (context, colors, child) {
//                           return Wrap(
//                             spacing: 10,
//                             runSpacing: 10,
//                             children: colors
//                                 .map(
//                                   (c) => ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: SizedBox(
//                                       width: 36,
//                                       height: 36,
//                                       child: child(c),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           );
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       const Text(
//                         "Pick Secondary Color",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       BlockPicker(
//                         pickerColor: selectedSecondary,
//                         onColorChanged: (color) =>
//                             setState(() => selectedSecondary = color),
//                         availableColors: aestheticColors,
//                         layoutBuilder: (context, colors, child) {
//                           return Wrap(
//                             spacing: 10,
//                             runSpacing: 10,
//                             children: colors
//                                 .map(
//                                   (c) => ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: SizedBox(
//                                       width: 36,
//                                       height: 36,
//                                       child: child(c),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     settings.setCustomTheme(selectedPrimary, selectedSecondary);
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Save"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settings = Provider.of<SettingsProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListView(
//         children: [
//           SwitchListTile(
//             title: const Text('Dark Mode'),
//             value: settings.isDarkMode,
//             onChanged: (value) {
//               settings.setDarkMode(value);
//             },
//             activeColor: Theme.of(context).colorScheme.onPrimary, // thumb
//             activeTrackColor: Theme.of(context).colorScheme.primary, // track
//             inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
//             inactiveTrackColor: Theme.of(context).colorScheme.surface,
//           ),
//           ListTile(
//             title: const Text('Theme'),
//             subtitle: Text(settings.selectedThemeName),
//             onTap: () {
//               _showThemeBottomSheet(context);
//             },
//           ),
//           ListTile(
//             title: const Text('Timer Name'),
//             subtitle: TextFormField(
//               controller: _timerNameController,
//               onFieldSubmitted: (value) {
//                 settings.setTimerName(value);
//               },
//             ),
//           ),
//           ListTile(
//             title: const Text('Daily Goal'),
//             subtitle: Text(
//               '${Provider.of<ProgressProvider>(context).dailyGoal} sessions',
//             ),
//             onTap: () => _showGoalDialog(context),
//           ),
//           SwitchListTile(
//             title: const Text('Enable Vibration'),
//             value: settings.isVibrationEnabled,
//             onChanged: (value) {
//               settings.setVibration(value);
//             },
//           ),
//           ListTile(
//             title: const Text('Work Duration'),
//             trailing: Text('${settings.workSeconds ~/ 60} min'),
//             onTap: () {
//               _showDurationPicker(
//                 context,
//                 "Work Duration",
//                 Duration(seconds: settings.workSeconds),
//                 (newDuration) => settings.setWorkSeconds(newDuration.inSeconds),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Break Duration'),
//             trailing: Text('${settings.breakSeconds ~/ 60} min'),
//             onTap: () {
//               _showDurationPicker(
//                 context,
//                 "Break Duration",
//                 Duration(seconds: settings.breakSeconds),
//                 (newDuration) =>
//                     settings.setBreakSeconds(newDuration.inSeconds),
//               );
//             },
//           ),

//           ListTile(
//             title: const Text('Alarm Sound'),
//             trailing: DropdownButton<String>(
//               value: settings.alarmSound,
//               items: const [
//                 DropdownMenuItem(value: 'none', child: Text('None')),
//                 DropdownMenuItem(value: 'audio/bell.wav', child: Text('Bell')),
//                 DropdownMenuItem(
//                   value: 'audio/alternating.wav',
//                   child: Text('Alternating'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'audio/intermittent.wav',
//                   child: Text('Intermittent'),
//                 ),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   settings.setAlarmSound(value);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showGoalDialog(BuildContext context) {
//     final progressProvider = Provider.of<ProgressProvider>(
//       context,
//       listen: false,
//     );
//     final goalController = TextEditingController(
//       text: progressProvider.dailyGoal.toString(),
//     );

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Theme.of(context).brightness == Brightness.light
//             ? Colors.white
//             : Colors.black,
//         title: const Text('Set Daily Goal'),
//         content: TextField(
//           controller: goalController,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(labelText: 'Number of sessions'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final goal = int.tryParse(goalController.text) ?? 0;
//               progressProvider.setDailyGoal(goal);
//               Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void _showDurationPicker(
//   BuildContext context,
//   String title,
//   Duration initialDuration,
//   Function(Duration) onSave,
// ) {
//   Duration newDuration = initialDuration;
//   final theme = Theme.of(context).colorScheme;

//   showCupertinoModalPopup<void>(
//     context: context,
//     builder: (context) {
//       return Container(
//         height: 320,
//         decoration: BoxDecoration(
//           color: Theme.of(context).brightness == Brightness.light
//               ? Colors.white
//               : Colors.black,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: CupertinoTheme(
//           data: CupertinoThemeData(
//             brightness: Theme.of(context).brightness,
//             primaryColor: Theme.of(context).brightness == Brightness.light
//                 ? Colors.white
//                 : Colors.black,

//             textTheme: CupertinoTextThemeData(
//               dateTimePickerTextStyle: TextStyle(
//                 color: theme.onSurface,
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           child: Column(
//             children: [
//               // 🔹 Top Action Bar
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).brightness == Brightness.light
//                       ? Colors.white
//                       : Colors.black,
//                   border: Border(
//                     bottom: BorderSide(
//                       color: theme.onSurface.withOpacity(0.1),
//                       width: 0.5,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                   children: [
//                     CupertinoButton(
//                       padding: EdgeInsets.zero,
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(color: theme.primary),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: theme.onSurface,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                     CupertinoButton(
//                       padding: EdgeInsets.zero,
//                       child: Text(
//                         'Save',
//                         style: TextStyle(color: theme.primary),
//                       ),
//                       onPressed: () {
//                         onSave(newDuration);
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1, thickness: 0.6), // thin separator
//               // 🔹 Timer Picker
//               Expanded(
//                 child: CupertinoTimerPicker(
//                   mode: CupertinoTimerPickerMode.ms,
//                   initialTimerDuration: initialDuration,
//                   onTimerDurationChanged: (duration) {
//                     newDuration = duration;
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pomodoo/progress_provider.dart';
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              Text(
                "Choose Theme",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: appThemes.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    if (index == appThemes.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showCustomThemeDialog(context, settings);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.palette_rounded, size: 48, color: Colors.white),
                                SizedBox(height: 12),
                                Text(
                                  "Custom",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.surface,
                              colorScheme.surfaceVariant.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: settings.selectedThemeName == theme.name
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
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
                                  radius: 16,
                                  backgroundColor: colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: colorScheme.secondary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              theme.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
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
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: const Text(
                "Custom Theme",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 480,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pick Primary Color",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      BlockPicker(
                        pickerColor: selectedPrimary,
                        onColorChanged: (color) =>
                            setState(() => selectedPrimary = color),
                        availableColors: aestheticColors,
                        layoutBuilder: (context, colors, child) {
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: colors
                                .map(
                                  (c) => ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: child(c),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Pick Secondary Color",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      BlockPicker(
                        pickerColor: selectedSecondary,
                        onColorChanged: (color) =>
                            setState(() => selectedSecondary = color),
                        availableColors: aestheticColors,
                        layoutBuilder: (context, colors, child) {
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: colors
                                .map(
                                  (c) => ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
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
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    settings.setCustomTheme(selectedPrimary, selectedSecondary);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                secondary: Icon(
                  Icons.brightness_6_rounded,
                  color: theme.onSurfaceVariant,
                ),
                value: settings.isDarkMode,
                onChanged: (value) {
                  settings.setDarkMode(value);
                },
                activeColor: theme.primary,
                activeTrackColor: theme.primary.withOpacity(0.5),
                inactiveThumbColor: theme.onSurfaceVariant,
                inactiveTrackColor: theme.surfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: const Text(
                  'Theme',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  settings.selectedThemeName,
                  style: TextStyle(color: theme.onSurfaceVariant),
                ),
                leading: Icon(
                  Icons.color_lens_rounded,
                  color: theme.onSurfaceVariant,
                ),
                onTap: () {
                  _showThemeBottomSheet(context);
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: const Text(
                  'Timer Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: TextFormField(
                  controller: _timerNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.surfaceVariant.withOpacity(0.3),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onFieldSubmitted: (value) {
                    settings.setTimerName(value);
                  },
                ),
                leading: Icon(
                  Icons.label_rounded,
                  color: theme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: const Text(
                  'Daily Goal',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${Provider.of<ProgressProvider>(context).dailyGoal} sessions',
                  style: TextStyle(color: theme.onSurfaceVariant),
                ),
                leading: Icon(
                  Icons.flag_rounded,
                  color: theme.onSurfaceVariant,
                ),
                onTap: () => _showGoalDialog(context),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Enable Vibration',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                secondary: Icon(
                  Icons.vibration_rounded,
                  color: theme.onSurfaceVariant,
                ),
                value: settings.isVibrationEnabled,
                onChanged: (value) {
                  settings.setVibration(value);
                },
                activeColor: theme.primary,
                activeTrackColor: theme.primary.withOpacity(0.5),
                inactiveThumbColor: theme.onSurfaceVariant,
                inactiveTrackColor: theme.surfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: const Text(
                  'Work Duration',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  '${settings.workSeconds ~/ 60} min',
                  style: TextStyle(color: theme.onSurfaceVariant),
                ),
                leading: Icon(
                  Icons.work_rounded,
                  color: theme.onSurfaceVariant,
                ),
                onTap: () {
                  _showDurationPicker(
                    context,
                    "Work Duration",
                    Duration(seconds: settings.workSeconds),
                    (newDuration) => settings.setWorkSeconds(newDuration.inSeconds),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: const Text(
                  'Break Duration',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  '${settings.breakSeconds ~/ 60} min',
                  style: TextStyle(color: theme.onSurfaceVariant),
                ),
                leading: Icon(
                  Icons.free_breakfast_rounded,
                  color: theme.onSurfaceVariant,
                ),
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
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: const Text(
                  'Alarm Sound',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: DropdownButton<String>(
                  value: settings.alarmSound,
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('None')),
                    DropdownMenuItem(value: 'audio/bell.wav', child: Text('Bell')),
                    DropdownMenuItem(
                      value: 'audio/alternating.wav',
                      child: Text('Alternating'),
                    ),
                    DropdownMenuItem(
                      value: 'audio/intermittent.wav',
                      child: Text('Intermittent'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      settings.setAlarmSound(value);
                    }
                  },
                  style: TextStyle(color: theme.onSurface),
                  dropdownColor: theme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.alarm_rounded,
                  color: theme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(
      context,
      listen: false,
    );
    final goalController = TextEditingController(
      text: progressProvider.dailyGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Set Daily Goal',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: goalController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of sessions',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final goal = int.tryParse(goalController.text) ?? 0;
              progressProvider.setDailyGoal(goal);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
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
          height: 340,
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Theme.of(context).brightness,
              primaryColor: theme.primary,
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: theme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.onSurface,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          onSave(newDuration);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.ms,
                    initialTimerDuration: initialDuration,
                    onTimerDurationChanged: (duration) {
                      newDuration = duration;
                    },
                    backgroundColor: theme.surface,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}