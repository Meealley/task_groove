import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'weekly_goals_state.dart';

class WeeklyGoalsCubit extends Cubit<WeeklyGoalsState> {
  WeeklyGoalsCubit() : super(WeeklyGoalsInitial());
}
