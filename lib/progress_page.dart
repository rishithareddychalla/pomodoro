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
    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _showPopup(
                    context,
                    "Today's Pomodoros",
                    progressProvider.dailyStreak,
                  ),
                  child: _buildStreakCard(
                    title: 'Today\'s Pomodoros',
                    streak: progressProvider.dailyStreak,
                    icon: Icons.today,
                    // color: Colors.blue,
                    context: context,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _showPopup(
                    context,
                    "Continuous Daily Streak",
                    progressProvider.continuousStreak,
                  ),
                  child: _buildStreakCard(
                    title: 'Continuous Daily Streak',
                    streak: progressProvider.continuousStreak,
                    icon: Icons.whatshot,
                    // color: Colors.orange,
                    context: context,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Monthly Progress (${DateFormat.yMMMM().format(DateTime.now())})',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
              ],
            ),
          );
        },
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.surface, // ✅ Card background from theme
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.primaryContainer, // ✅ theme accent
              child: Icon(icon, size: 28, color: theme.onPrimaryContainer),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.onSurface, // ✅ themed text
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$streak ${title.contains("Streak") ? "days" : "sessions"}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.primary, // ✅ highlight with theme.primary
                  ),
                ),
              ],
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
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final maxSessions = monthlyProgress.values.isNotEmpty
        ? monthlyProgress.values.reduce((a, b) => a > b ? a : b)
        : 0;

    // Round up to nearest 10 and give breathing space
    final maxY = (((maxSessions + 9) ~/ 10) * 10) + 10;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY.toDouble(),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8.0),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.round()} sessions',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return Container();
            },
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 10, // ✅ force labels every 10 units
            getTitlesWidget: (value, meta) {
              if (value == 0) return Container();
              return Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 11),
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
        horizontalInterval: 10, // ✅ consistent grid every 10
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
              color: Theme.of(context).primaryColor,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: repaintKey,
              child: _buildShareableCard(context, title, streak),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text("Share"),
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
                    ], text: "Check out my $title!");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildShareableCard(String title, int streak) {
  //   return Container(
  //     width: 280,
  //     padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.15),
  //           blurRadius: 12,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           title.contains("Streak") ? Icons.whatshot : Icons.today,
  //           size: 48,
  //           color: Colors.white,
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           title,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.white,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Text(
  //           '$streak ${title.contains("Streak") ? "days 🔥" : "sessions ✅"}',
  //           style: const TextStyle(
  //             fontSize: 30,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.yellowAccent,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         const Text(
  //           "Keep pushing your limits 🚀",
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.white70,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildShareableCard(BuildContext context, String title, int streak) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.surface, // ✅ theme-based background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: theme.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.primaryContainer,
            child: Icon(
              title.contains("Streak") ? Icons.whatshot : Icons.today,
              size: 30,
              color: theme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$streak ${title.contains("Streak") ? "days 🔥" : "sessions ✅"}',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Keep pushing your limits 🚀",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
