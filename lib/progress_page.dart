
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';
// import 'progress_provider.dart';

// class ProgressPage extends StatelessWidget {
//   const ProgressPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Your Progress')),
//       body: Consumer<ProgressProvider>(
//         builder: (context, progressProvider, child) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildGoalProgressCard(context, progressProvider),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () => _showPopup(
//                     context,
//                     "Today's Pomodoros",
//                     progressProvider.dailySessions,
//                   ),
//                   child: _buildStreakCard(
//                     title: 'Today\'s Pomodoros',
//                     streak: progressProvider.dailySessions,
//                     icon: Icons.today,
//                     context: context,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () => _showPopup(
//                     context,
//                     "Continuous Daily Streak",
//                     progressProvider.continuousStreak,
//                   ),
//                   child: _buildStreakCard(
//                     title: 'Continuous Daily Streak',
//                     streak: progressProvider.continuousStreak,
//                     icon: Icons.whatshot,
//                     context: context,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   'Monthly Progress (${DateFormat.yMMMM().format(DateTime.now())})',
//                   style: Theme.of(context).textTheme.titleLarge,
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   height: 320,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).brightness == Brightness.light
//                         ? Colors.white
//                         : Colors.black,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: BarChart(
//                     _buildMonthlyChart(
//                       context,
//                       progressProvider.monthlyProgress,
//                     ),
//                     swapAnimationDuration: const Duration(milliseconds: 800),
//                     swapAnimationCurve: Curves.easeInOut,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStreakCard({
//     required BuildContext context,
//     required String title,
//     required int streak,
//     required IconData icon,
//   }) {
//     final theme = Theme.of(context).colorScheme;

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Theme.of(context).brightness == Brightness.light
//           ? Colors.white
//           : Colors.black,
//       surfaceTintColor: Colors.transparent,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 24,
//               backgroundColor: theme.primaryContainer,
//               child: Icon(icon, size: 28, color: theme.onPrimaryContainer),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: theme.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$streak ${title.contains("Streak") ? "days" : "sessions"}',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: theme.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   BarChartData _buildMonthlyChart(
//     BuildContext context,
//     Map<int, int> monthlyProgress,
//   ) {
//     final theme = Theme.of(context).colorScheme;
//     final now = DateTime.now();
//     final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

//     final maxSessions = monthlyProgress.values.isNotEmpty
//         ? monthlyProgress.values.reduce((a, b) => a > b ? a : b)
//         : 0;

//     final maxY = (((maxSessions + 9) ~/ 10) * 10) + 10;

//     return BarChartData(
//       alignment: BarChartAlignment.spaceAround,
//       maxY: maxY.toDouble(),
//       barTouchData: BarTouchData(
//         enabled: true,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipPadding: const EdgeInsets.all(8.0),
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             return BarTooltipItem(
//               '${rod.toY.round()} sessions',
//               const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             );
//           },
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: (double value, TitleMeta meta) {
//               final day = value.toInt();
//               if (day % 5 == 0 || day == 1 || day == daysInMonth) {
//                 return SideTitleWidget(
//                   meta: meta,
//                   child: Text(
//                     day.toString(),
//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 );
//               }
//               return Container();
//             },
//             reservedSize: 28,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 40,
//             interval: 10,
//             getTitlesWidget: (value, meta) {
//               if (value == 0) return Container();
//               return Text(
//                 value.toInt().toString(),
//                 style: const TextStyle(fontSize: 11),
//               );
//             },
//           ),
//         ),
//         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       ),
//       borderData: FlBorderData(show: false),
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: false,
//         horizontalInterval: 10,
//       ),
//       barGroups: List.generate(daysInMonth, (index) {
//         final day = index + 1;
//         final sessionCount = monthlyProgress[day] ?? 0;
//         return BarChartGroupData(
//           x: day,
//           barRods: [
//             BarChartRodData(
//               fromY: 0,
//               toY: sessionCount.toDouble(),
//               color: Theme.of(context).brightness == Brightness.light
//                   ? theme.primary
//                   : theme.secondary,
//               width: 12,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(6),
//                 topRight: Radius.circular(6),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   void _showPopup(BuildContext context, String title, int streak) {
//     final GlobalKey repaintKey = GlobalKey();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: Theme.of(context).brightness == Brightness.light
//             ? Colors.white
//             : Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         contentPadding: EdgeInsets.zero,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             RepaintBoundary(
//               key: repaintKey,
//               child: _buildShareableCard(
//                 context,
//                 title,
//                 streak,
//                 type: title.contains("Streak") ? 'streak' : 'sessions',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.share),
//               label: const Text("Share"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).brightness == Brightness.light
//                     ? Theme.of(context).colorScheme.primary
//                     : Theme.of(context).colorScheme.secondary,
//                 foregroundColor: Theme.of(context).brightness == Brightness.light
//                     ? Colors.black
//                     : Colors.white,
//               ),
//               onPressed: () async {
//                 final boundary =
//                     repaintKey.currentContext?.findRenderObject()
//                         as RenderRepaintBoundary?;
//                 if (boundary != null) {
//                   final image = await boundary.toImage(pixelRatio: 3.0);
//                   final byteData = await image.toByteData(
//                     format: ui.ImageByteFormat.png,
//                   );
//                   if (byteData != null) {
//                     final pngBytes = byteData.buffer.asUint8List();
//                     final xFile = XFile.fromData(
//                       pngBytes,
//                       mimeType: 'image/png',
//                       name: "progress.png",
//                     );
//                     await Share.shareXFiles([
//                       xFile,
//                     ], text: "Check out my $title!");
//                   }
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShareableCard(
//     BuildContext context,
//     String title,
//     int streak, {
//     required String type,
//   }) {
//     final theme = Theme.of(context).colorScheme;

//     IconData icon;
//     String displayText;
//     switch (type) {
//       case 'streak':
//         icon = Icons.whatshot;
//         displayText = '$streak days 🔥';
//         break;
//       case 'sessions':
//         icon = Icons.today;
//         displayText = '$streak sessions ✅';
//         break;
//       case 'goal':
//         icon = Icons.check_circle;
//         displayText = '$streak sessions 🎉';
//         break;
//       default:
//         icon = Icons.today;
//         displayText = '$streak sessions';
//     }

//     return Container(
//       width: 280,
//       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.light
//             ? Colors.white
//             : Colors.black,
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
//             child: Icon(icon, size: 30, color: theme.onPrimaryContainer),
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
//             displayText,
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//               color: theme.primary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "Keep pushing your limits 🚀",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: theme.onSurfaceVariant,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGoalProgressCard(
//     BuildContext context,
//     ProgressProvider progressProvider,
//   ) {
//     final theme = Theme.of(context).colorScheme;
//     final hasGoal = progressProvider.dailyGoal > 0;
//     final progress = hasGoal
//         ? (progressProvider.dailySessions / progressProvider.dailyGoal).clamp(
//             0.0,
//             1.0,
//           )
//         : 0.0;
//     final isGoalCompleted =
//         hasGoal && progressProvider.dailySessions >= progressProvider.dailyGoal;

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Theme.of(context).brightness == Brightness.light
//           ? Colors.white
//           : Colors.black,
//       surfaceTintColor: Colors.transparent,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Today\'s Goal',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.onSurface,
//               ),
//             ),
//             const SizedBox(height: 8),
//             if (hasGoal) ...[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${progressProvider.dailySessions} / ${progressProvider.dailyGoal} sessions',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: theme.onSurfaceVariant,
//                     ),
//                   ),
//                   Text(
//                     '${(progress * 100).toStringAsFixed(0)}%',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: theme.primary,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               LinearProgressIndicator(
//                 value: progress,
//                 minHeight: 10,
//                 borderRadius: BorderRadius.circular(10),
//                 color: theme.primary,
//                 backgroundColor: Colors.grey[300],
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextButton(
//                       onPressed: () => progressProvider.resetDailyGoal(),
//                       child: const Text('Reset Goal'),
//                     ),
//                     if (isGoalCompleted) ...[
//                       const SizedBox(width: 8),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.share, size: 18),
//                         label: const Text('Share'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Theme.of(context).brightness == Brightness.light
//                                   ? theme.primary
//                                   : theme.secondary,
//                           foregroundColor:
//                               Theme.of(context).brightness == Brightness.light
//                                   ? Colors.black
//                                   : Colors.white,
//                         ),
//                         onPressed: () async {
//                           final GlobalKey repaintKey = GlobalKey();
//                           showDialog(
//                             context: context,
//                             builder: (_) => AlertDialog(
//                               backgroundColor:
//                                   Theme.of(context).brightness == Brightness.light
//                                       ? Colors.white
//                                       : Colors.black,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               contentPadding: EdgeInsets.zero,
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   RepaintBoundary(
//                                     key: repaintKey,
//                                     child: _buildShareableCard(
//                                       context,
//                                       "Goal Completed!",
//                                       progressProvider.dailySessions,
//                                       type: 'goal',
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                   ElevatedButton.icon(
//                                     icon: const Icon(Icons.share),
//                                     label: const Text("Share"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Theme.of(context).brightness ==
//                                                   Brightness.light
//                                               ? theme.primary
//                                               : theme.secondary,
//                                       foregroundColor:
//                                           Theme.of(context).brightness ==
//                                                   Brightness.light
//                                               ? Colors.black
//                                               : Colors.white,
//                                     ),
//                                     onPressed: () async {
//                                       final boundary =
//                                           repaintKey.currentContext
//                                                   ?.findRenderObject()
//                                               as RenderRepaintBoundary?;
//                                       if (boundary != null) {
//                                         final image = await boundary.toImage(
//                                           pixelRatio: 3.0,
//                                         );
//                                         final byteData = await image.toByteData(
//                                           format: ui.ImageByteFormat.png,
//                                         );
//                                         if (byteData != null) {
//                                           final pngBytes = byteData.buffer
//                                               .asUint8List();
//                                           final xFile = XFile.fromData(
//                                             pngBytes,
//                                             mimeType: 'image/png',
//                                             name: "goal_completed.png",
//                                           );
//                                           await Share.shareXFiles(
//                                             [xFile],
//                                             text:
//                                                 "I completed my daily goal of ${progressProvider.dailyGoal} sessions!",
//                                           );
//                                         }
//                                       }
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ] else ...[
//               Text(
//                 'No goal set for today. Set a goal to track your progress!',
//                 style: TextStyle(fontSize: 16, color: theme.onSurfaceVariant),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: () =>
//                       _showSetGoalDialog(context, progressProvider),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Theme.of(context).brightness == Brightness.light
//                             ? theme.primary
//                             : theme.secondary,
//                     foregroundColor:
//                         Theme.of(context).brightness == Brightness.light
//                             ? Colors.black
//                             : Colors.white,
//                   ),
//                   child: const Text('Set Goal'),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSetGoalDialog(
//     BuildContext context,
//     ProgressProvider progressProvider,
//   ) {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Theme.of(context).brightness == Brightness.light
//             ? Colors.white
//             : Colors.black,
//         title: const Text('Set Daily Goal'),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             labelText: 'Number of sessions',
//             hintText: 'Enter a number (e.g., 5)',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final value = int.tryParse(controller.text);
//               if (value != null && value > 0) {
//                 progressProvider.setDailyGoal(value);
//                 Navigator.pop(context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Please enter a valid number greater than 0'),
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).brightness == Brightness.light
//                   ? Theme.of(context).colorScheme.primary
//                   : Theme.of(context).colorScheme.secondary,
//               foregroundColor: Theme.of(context).brightness == Brightness.light
//                   ? Colors.black
//                   : Colors.white,
//             ),
//             child: const Text('Set'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'progress_provider.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Progress',
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
        child: Consumer<ProgressProvider>(
          builder: (context, progressProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildGoalProgressCard(context, progressProvider),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showPopup(
                      context,
                      "Today's Pomodoros",
                      progressProvider.dailySessions,
                    ),
                    child: _buildStreakCard(
                      title: 'Today\'s Pomodoros',
                      streak: progressProvider.dailySessions,
                      icon: Icons.today_rounded,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showPopup(
                      context,
                      "Continuous Daily Streak",
                      progressProvider.continuousStreak,
                    ),
                    child: _buildStreakCard(
                      title: 'Continuous Daily Streak',
                      streak: progressProvider.continuousStreak,
                      icon: Icons.whatshot_rounded,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Monthly Progress (${DateFormat.yMMMM().format(DateTime.now())})',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 340,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: BarChart(
                        _buildMonthlyChart(
                          context,
                          progressProvider.monthlyProgress,
                        ),
                        swapAnimationDuration: const Duration(milliseconds: 800),
                        swapAnimationCurve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStreakCard({
    required BuildContext context,
    required String title,
    required int streak,
    required IconData icon,
  }) {
    final theme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.primaryContainer,
              child: Icon(icon, size: 32, color: theme.onPrimaryContainer),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$streak ${title.contains("Streak") ? "days" : "sessions"}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData _buildMonthlyChart(
    BuildContext context,
    Map<int, int> monthlyProgress,
  ) {
    final theme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final maxSessions = monthlyProgress.values.isNotEmpty
        ? monthlyProgress.values.reduce((a, b) => a > b ? a : b)
        : 0;

    final maxY = (((maxSessions + 9) ~/ 10) * 10) + 10;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY.toDouble(),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(10),
          // tooltipBgColor: theme.primary.withOpacity(0.9),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.round()} sessions',
              TextStyle(
                color: theme.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              final day = value.toInt();
              if (day % 5 == 0 || day == 1 || day == daysInMonth) {
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return Container();
            },
            reservedSize: 32,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            interval: 10,
            getTitlesWidget: (value, meta) {
              if (value == 0) return Container();
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.onSurface.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      barGroups: List.generate(daysInMonth, (index) {
        final day = index + 1;
        final sessionCount = monthlyProgress[day] ?? 0;
        return BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: sessionCount.toDouble(),
              gradient: LinearGradient(
                colors: [
                  theme.primary,
                  theme.secondary,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 14,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showPopup(BuildContext context, String title, int streak) {
    final GlobalKey repaintKey = GlobalKey();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: repaintKey,
              child: _buildShareableCard(
                context,
                title,
                streak,
                type: title.contains("Streak") ? 'streak' : 'sessions',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.share_rounded, size: 20),
              label: const Text("Share"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      name: "progress.png",
                    );
                    await Share.shareXFiles([
                      xFile,
                    ], text: "Check out my $title! 🚀");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareableCard(
    BuildContext context,
    String title,
    int streak, {
    required String type,
  }) {
    final theme = Theme.of(context).colorScheme;

    IconData icon;
    String displayText;
    switch (type) {
      case 'streak':
        icon = Icons.whatshot_rounded;
        displayText = '$streak days 🔥';
        break;
      case 'sessions':
        icon = Icons.today_rounded;
        displayText = '$streak sessions ✅';
        break;
      case 'goal':
        icon = Icons.check_circle_rounded;
        displayText = '$streak sessions 🎉';
        break;
      default:
        icon = Icons.today_rounded;
        displayText = '$streak sessions';
    }

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
            child: Icon(icon, size: 36, color: theme.onPrimaryContainer),
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
            displayText,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Keep pushing your limits 🚀",
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

  Widget _buildGoalProgressCard(
    BuildContext context,
    ProgressProvider progressProvider,
  ) {
    final theme = Theme.of(context).colorScheme;
    final hasGoal = progressProvider.dailyGoal > 0;
    final progress = hasGoal
        ? (progressProvider.dailySessions / progressProvider.dailyGoal).clamp(
            0.0,
            1.0,
          )
        : 0.0;
    final isGoalCompleted =
        hasGoal && progressProvider.dailySessions >= progressProvider.dailyGoal;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Goal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            if (hasGoal) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${progressProvider.dailySessions} / ${progressProvider.dailyGoal} sessions',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                borderRadius: BorderRadius.circular(12),
                color: theme.primary,
                backgroundColor: theme.surfaceVariant,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => progressProvider.resetDailyGoal(),
                      child: Text(
                        'Reset Goal',
                        style: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isGoalCompleted) ...[
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.share_rounded, size: 18),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: theme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          final GlobalKey repaintKey = GlobalKey();
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: theme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.zero,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RepaintBoundary(
                                    key: repaintKey,
                                    child: _buildShareableCard(
                                      context,
                                      "Goal Completed! 🎉",
                                      progressProvider.dailySessions,
                                      type: 'goal',
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.share_rounded, size: 20),
                                    label: const Text("Share"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primary,
                                      foregroundColor: theme.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      elevation: 2,
                                    ),
                                    onPressed: () async {
                                      final boundary =
                                          repaintKey.currentContext
                                                  ?.findRenderObject()
                                              as RenderRepaintBoundary?;
                                      if (boundary != null) {
                                        final image = await boundary.toImage(
                                          pixelRatio: 3.0,
                                        );
                                        final byteData = await image.toByteData(
                                          format: ui.ImageByteFormat.png,
                                        );
                                        if (byteData != null) {
                                          final pngBytes = byteData.buffer
                                              .asUint8List();
                                          final xFile = XFile.fromData(
                                            pngBytes,
                                            mimeType: 'image/png',
                                            name: "goal_completed.png",
                                          );
                                          await Share.shareXFiles(
                                            [xFile],
                                            text:
                                                "I completed my daily goal of ${progressProvider.dailyGoal} sessions! 🎉",
                                          );
                                        }
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ] else ...[
              Text(
                'No goal set for today. Set a goal to track your progress!',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () =>
                      _showSetGoalDialog(context, progressProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: theme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Set Goal',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSetGoalDialog(
    BuildContext context,
    ProgressProvider progressProvider,
  ) {
    final controller = TextEditingController();
    final theme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Set Daily Goal',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of sessions',
            hintText: 'Enter a number (e.g., 5)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.surfaceVariant.withOpacity(0.3),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                progressProvider.setDailyGoal(value);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                        'Please enter a valid number greater than 0'),
                    backgroundColor: theme.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: theme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Set',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}