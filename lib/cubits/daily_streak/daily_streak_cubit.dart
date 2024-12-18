import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'daily_streak_state.dart';

class DailyStreakCubit extends Cubit<DailyStreakState> {
  DailyStreakCubit() : super(DailyStreakInitial());
}
