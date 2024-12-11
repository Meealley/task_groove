import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:task_groove/cubit/completed_task_per_day_cubit.dart';
import 'package:task_groove/cubits/completed_task_per_day/completed_task_per_day_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  final Color barBackgroundColor = AppColors.textWhite;
  final Color barColor = AppColors.textPrimary;
  final Color touchedBarColor = AppColors.backgroundDark;

  @override
  State<StatefulWidget> createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Trigger fetching tasks when the page is initialized
    context.read<CompletedTaskPerDayCubit>().fetchCompletedTasksPerDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Productivity Statistics",
          style: AppTextStyles.bodyTextLg,
        ),
      ),
      body: BlocBuilder<CompletedTaskPerDayCubit, CompletedTaskPerDayState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.hasError) {
            return Center(
              child: Text(
                state.message ?? 'An error occurred',
                style: AppTextStyles.bodyText.copyWith(color: Colors.red),
              ),
            );
          } else {
            final completedTasksPerDay = state.completedTasksPerDay ?? {};
            return Column(
              children: [
                SizedBox(
                  height: 700,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Weekly Productivity',
                            style: AppTextStyles.bodyTextBold.copyWith(
                              fontSize: 35,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Number of tasks completed each day',
                            style: AppTextStyles.bodyText,
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: BarChart(
                                mainBarData(completedTasksPerDay),
                                duration: animDuration,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(
      Map<DateTime, int> completedTasksPerDay) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();

    // Get tasks for the last 7 days
    List<int> tasksPerDay = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      final dayOnly = DateTime(day.year, day.month, day.day);
      return completedTasksPerDay[dayOnly] ?? 0;
    });

    return List.generate(7, (i) {
      return makeGroupData(i, tasksPerDay[i].toDouble(),
          isTouched: i == touchedIndex);
    });
  }

  BarChartData mainBarData(Map<DateTime, int> completedTasksPerDay) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final day = days[group.x];
            final tasks = rod.toY.toInt();
            return BarTooltipItem(
              '$day\n',
              AppTextStyles.bodyText.copyWith(color: Colors.white),
              children: [
                TextSpan(
                  text: '$tasks tasks',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final day = value.toInt();
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  days[day],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(completedTasksPerDay),
      gridData: const FlGridData(show: false),
    );
  }
}
