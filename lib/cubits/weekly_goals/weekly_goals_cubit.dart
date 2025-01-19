import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_groove/cubits/completed_task_per_week/completed_task_per_week_cubit.dart';

part 'weekly_goals_state.dart';

class WeeklyGoalsCubit extends Cubit<WeeklyGoalsState> {
  final CompletedTaskPerWeekCubit completedTaskPerWeekCubit;
  late final StreamSubscription completedTaskPerWeekSubscription;

  WeeklyGoalsCubit({required this.completedTaskPerWeekCubit})
      : super(WeeklyGoalsState.initial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadGoals();

    completedTaskPerWeekSubscription = completedTaskPerWeekCubit.stream
        .listen((CompletedTaskPerWeekState completedTaskPerWeekState) {
      final now = DateTime.now();
      final currentWeek = _getWeekOfYear(now);

      final completedTasks =
          completedTaskPerWeekState.tasksPerWeek[currentWeek] ?? 0;
      emit(state.copyWith(completedTask: completedTasks));
    });
  }

  Future<void> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final totalTasks = prefs.getInt('totalWeekGoalTask');
    emit(state.copyWith(totalTasks: totalTasks));
  }

  Future<void> updateTotalTasks(int totalTasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("totalWeekGoalTask", totalTasks);
    emit(state.copyWith(totalTasks: totalTasks));
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }

  @override
  Future<void> close() {
    completedTaskPerWeekSubscription.cancel();
    return super.close();
  }
}
