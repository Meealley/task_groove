import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'daily_goals_state.dart';

class DailyGoalsCubit extends Cubit<DailyGoalsState> {
  DailyGoalsCubit() : super(DailyGoalsState.initial()) {
    loadGoals();
  }

// TODO: IMPLEMENT THE CUBIT FOR THE COMPLETEDTASK
// TODO: SYNC THE COMPLETEDTASK WITH THE FETCHDAILY TASK

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
}
