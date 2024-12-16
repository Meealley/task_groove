import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_groove/cubits/daily_goals/daily_goals_cubit.dart';

part 'goal_celebration_state.dart';

class GoalCelebrationCubit extends Cubit<GoalCelebrationState> {
  final DailyGoalsCubit dailyGoalsCubit;
  late final StreamSubscription _dailyGoalsSubscription;

  GoalCelebrationCubit({required this.dailyGoalsCubit})
      : super(GoalCelebrationState.initial()) {
    _dailyGoalsSubscription =
        dailyGoalsCubit.stream.listen((DailyGoalsState dailyGoalsState) {
      _loadCelebrationPreference();
      _handleDailyGoalsUpdate(dailyGoalsState);
    });
  }

  void _handleDailyGoalsUpdate(DailyGoalsState dailyGoalsState) {
    final isAlltTaskCompleted =
        dailyGoalsState.completedTasks == dailyGoalsState.totalTasks &&
            dailyGoalsState.totalTasks > 0;

    if (isAlltTaskCompleted && state.triggerCelebration) {
      emit(state.copyWith(triggerCelebration: true));
    } else {
      emit(state.copyWith(triggerCelebration: false));
    }

    // final completedTask = dailyGoalsState.completedTasks;
    // final totalTasks = dailyGoalsState.totalTasks;

    // final goalsCompleted = totalTasks > 0 && completedTask == totalTasks;

    // emit(state.copyWith(
    //   goalsCompleted: goalsCompleted,
    //   triggerCelebration: goalsCompleted && state.triggerCelebration,
    // ));
  }

  void toggleCelebration(bool isEnabled) async {
    emit(state.copyWith(triggerCelebration: isEnabled));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isCelebrationEnabled", isEnabled);
  }

  Future<void> _loadCelebrationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('isCelebrationEnabled') ?? false;
    emit(state.copyWith(triggerCelebration: isEnabled));
  }

  // void updateGoalStatus(
  //     int completedTask, int totalTasks, bool isCelebrationEnabled) {
  //   final goalCompleted = totalTasks > 0 && completedTask == totalTasks;
  //   final shouldTrigger = goalCompleted && isCelebrationEnabled;

  //   emit(state.copyWith(
  //       goalsCompleted: goalCompleted, triggerCelebration: shouldTrigger));
  // }

  // void triggerCelebration() {
  //   if (state.goalsCompleted) {
  //     emit(state.copyWith(triggerCelebration: !state.triggerCelebration));
  //   }

  //   // // if(state.goalsCompleted)
  // }

  // void resetDailyGoals() {
  //   emit(
  //     state.copyWith(goalsCompleted: false, triggerCelebration: false),
  //   );
  // }

  @override
  Future<void> close() {
    _dailyGoalsSubscription.cancel();
    return super.close();
  }
}
