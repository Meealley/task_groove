import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/completed_task_per_day/completed_task_per_day_cubit.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/cubits/daily_streak/daily_streak_cubit.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/cubits/total_completed_task_count/total_completed_task_count_cubit.dart';
import 'package:task_groove/presentation/profile/statistics/daily_streaks/daily_streaks.dart';
import 'package:task_groove/presentation/profile/statistics/daily_weekly_goals.dart/daily_goals.dart';
import 'package:task_groove/presentation/profile/statistics/daily_weekly_goals.dart/weekly_goals.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  final Color barBackgroundColor = AppColors.textWhite;
  final Color barColor = const Color.fromARGB(255, 103, 187, 106);
  final Color touchedBarColor = Colors.green;

  @override
  State<StatefulWidget> createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  @override
  void initState() {
    context.read<TaskListCubit>().fetchTasks();

    context.read<TotalCompletedTaskCountCubit>();
    context.read<DailyStreakCubit>().fetchStreakData();

    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Productivity",
            style: AppTextStyles.headingBold.copyWith(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => context.pop(),
            color: Colors.white,
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
            ),
          ),
          bottom: TabBar(
            labelStyle: AppTextStyles.bodyText.copyWith(color: Colors.white),
            tabs: const [
              Tab(
                text: 'Daily Goals',
              ),
              Tab(text: 'Weekly Goals'),
            ],
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
              final completedTasksPerDay = state.tasksPerDay;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: .4.h),
                      BlocBuilder<TotalCompletedTaskCountCubit,
                          TotalCompletedTaskCountState>(
                        builder: (context, state) {
                          return Text(
                            'Total Completed Tasks: ${state.totalTaskCount}',
                            style: AppTextStyles.bodyText
                                .copyWith(fontWeight: FontWeight.w900),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 125,
                        child: TabBarView(
                          children: [
                            DailyGoals(),
                            WeeklyGoals(),
                          ],
                        ),
                      ),
                      const Divider(),
                      const DailyStreaks(),
                      const Divider(),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: 450,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: BlocBuilder<ThemeCubit, ThemeState>(
                                  builder: (context, state) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: state.color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 15,
                                      ),
                                      child: BarChart(
                                        mainBarData(completedTasksPerDay),
                                        duration: animDuration,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
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
    // final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    // Get tasks for the last 7 days
    List<int> tasksPerDay = List.generate(7, (index) {
      final day = DateTime(today.year, today.month, today.day - (6 - index));
      final normalizedDay = DateTime(day.year, day.month, day.day);
      return completedTasksPerDay[normalizedDay] ?? 0;
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
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final day = today.subtract(Duration(days: 6 - group.x));
          final dayName = [
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat',
            'Sun'
          ][day.weekday - 1];
          return BarTooltipItem(
            '$dayName\n',
            AppTextStyles.bodyText.copyWith(color: Colors.white),
            children: [
              TextSpan(
                text: '${rod.toY.toInt()} tasks',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          );
        }),
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
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final day = today.subtract(Duration(days: 6 - value.toInt()));
              final dayName = [
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
                'Sat',
                'Sun'
              ][day.weekday - 1];
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 7,
                child: Text(
                  dayName,
                  style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 42,
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(completedTasksPerDay),
      gridData: const FlGridData(show: false),
    );
  }
}
