import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_groove/cubits/completed_task_per_day/completed_task_per_day_cubit.dart';

part 'daily_goals_state.dart';

class DailyGoalsCubit extends Cubit<DailyGoalsState> {
  final CompletedTaskPerDayCubit completedTaskPerDayCubit;
  late final StreamSubscription completeTaskPerDaySubscription;
  DailyGoalsCubit({required this.completedTaskPerDayCubit})
      : super(DailyGoalsState.initial()) {
    _initialize();
  }

// TODO: IMPLEMENT THE CUBIT FOR THE COMPLETEDTASK
// TODO: SYNC THE COMPLETEDTASK WITH THE FETCHDAILY TASK

  Future<void> _initialize() async {
    await loadGoals();

    // monitor changes in CompletedTaskPerDay
    completeTaskPerDaySubscription = completedTaskPerDayCubit.stream
        .listen((CompletedTaskPerDayState completedTaskPerDayState) {
      final today = DateTime.now();

      final normalizedToday = DateTime(today.year, today.month, today.day);

      // Logic for completedTask for today
      final completedTasks =
          completedTaskPerDayState.tasksPerDay[normalizedToday];
      emit(state.copyWith(completedTasks: completedTasks));
    });
  }

  Future<void> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final totalTasks = prefs.getInt('totalGoalTask');

    emit(state.copyWith(totalTasks: totalTasks));
  }

  Future<void> udpateTotalTasks(int totalTasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalGoalTask', totalTasks);
    emit(state.copyWith(totalTasks: totalTasks));
  }

  @override
  Future<void> close() {
    completeTaskPerDaySubscription.cancel();
    return super.close();
  }
}
