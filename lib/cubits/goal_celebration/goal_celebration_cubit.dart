import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_groove/cubits/daily_goals/daily_goals_cubit.dart';

part 'goal_celebration_state.dart';

class GoalCelebrationCubit extends Cubit<GoalCelebrationState> {
  final DailyGoalsCubit dailyGoalsCubit;
  late final StreamSubscription _dailyGoalsSubscription;

  bool goalCompletedPreviously = false;

  GoalCelebrationCubit({required this.dailyGoalsCubit})
      : super(GoalCelebrationState.initial()) {
    _loadCelebrationPreference();
    _dailyGoalsSubscription =
        dailyGoalsCubit.stream.listen((DailyGoalsState dailyGoalsState) {
      _handleDailyGoalsUpdate(dailyGoalsState);
    });
  }

  void _handleDailyGoalsUpdate(DailyGoalsState dailyGoalsState) async {
    final isAlltTaskCompleted =
        dailyGoalsState.completedTasks == dailyGoalsState.totalTasks &&
            dailyGoalsState.totalTasks > 0;

    if (isAlltTaskCompleted && state.isCelebrationEnabled) {
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(triggerCelebration: true));
    } else {
      emit(state.copyWith(triggerCelebration: false));
    }
  }

  void toggleCelebration(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isCelebrationEnabled", isEnabled);
    emit(
      state.copyWith(
        triggerCelebration: false,
        isCelebrationEnabled: isEnabled,
      ),
    );
  }

  Future<void> _loadCelebrationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('isCelebrationEnabled') ?? false;
    emit(state.copyWith(isCelebrationEnabled: isEnabled));
  }

  @override
  Future<void> close() {
    _dailyGoalsSubscription.cancel();
    return super.close();
  }
}
