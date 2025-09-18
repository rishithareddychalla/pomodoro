import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'progress_provider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final TextEditingController _goalController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _showSetGoalDialog(BuildContext context, ProgressProvider provider) async {
    _goalController.text = provider.dailyGoal > 0 ? provider.dailyGoal.toString() : '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Daily Goal'),
          content: TextField(
            controller: _goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Number of sessions',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final goal = int.tryParse(_goalController.text);
                if (goal != null && goal > 0) {
                  provider.setDailyGoal(goal);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareAchievement(BuildContext context, ProgressProvider provider) async {
    final image = await _screenshotController.captureFromWidget(
      AchievementShareable(
        goal: provider.dailyGoal,
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/achievement.png').create();
    await imagePath.writeAsBytes(image);

    await Share.shareXFiles([XFile(imagePath.path)]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Lottie.network(
                  'https://assets9.lottiefiles.com/packages/lf20_touohxv0.json',
                  height: 200,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showSetGoalDialog(context, progressProvider),
                  child: const Text('Set Daily Goal'),
                ),
                const SizedBox(height: 16),
                _buildGoalProgressCard(context, progressProvider),
                const SizedBox(height: 24),
                _buildStreakCard(
                  title: 'Today\'s Pomodoros',
                  streak: progressProvider.dailyStreak,
                  icon: Icons.today,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildStreakCard(
                  title: 'Continuous Daily Streak',
                  streak: progressProvider.continuousStreak,
                  icon: Icons.whatshot,
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                Text(
                  'Monthly Progress (${DateFormat.yMMMM().format(DateTime.now())})',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    _buildMonthlyChart(context, progressProvider.monthlyProgress),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalProgressCard(BuildContext context, ProgressProvider provider) {
    if (provider.dailyGoal == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Goal Progress',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (provider.isGoalCompleted)
              Column(
                children: [
                  const Text(
                    '🎉 Congratulations! You\'ve reached your daily goal! 🎉',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _shareAchievement(context, provider),
                        child: const Text('Share'),
                      ),
                      ElevatedButton(
                        onPressed: () => _showSetGoalDialog(context, provider),
                        child: const Text('Reset Goal'),
                      ),
                    ],
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${provider.dailyStreak} / ${provider.dailyGoal} sessions completed',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: provider.goalProgress,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard({
    required String title,
    required int streak,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$streak ${title.contains("Streak") ? "days" : "sessions"}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BarChartData _buildMonthlyChart(BuildContext context, Map<int, int> monthlyProgress) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: (monthlyProgress.values.isNotEmpty ? monthlyProgress.values.reduce((a, b) => a > b ? a : b) : 0) + 2.0,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.round()} sessions',
              const TextStyle(color: Colors.white),
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
                  axisSide: meta.axisSide,
                  space: 4.0,
                  child: Text(day.toString()),
                );
              }
              return Container();
            },
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: true, drawVerticalLine: false),
      barGroups: List.generate(daysInMonth, (index) {
        final day = index + 1;
        final sessionCount = monthlyProgress[day] ?? 0;
        return BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
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
}

class AchievementShareable extends StatelessWidget {
  final int goal;
  const AchievementShareable({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'I completed my goal of $goal pomodoros today!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Powered by Pomodoro App',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
