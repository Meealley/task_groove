import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'goal_celebration_state.dart';

class GoalCelebrationCubit extends Cubit<GoalCelebrationState> {
  GoalCelebrationCubit() : super(GoalCelebrationState.initial());

  void triggerCelebration() {
    emit(state.copyWith(triggerCelebration: true));

    Future.delayed(const Duration(seconds: 3), () {
      emit(state.copyWith(triggerCelebration: false));
    });
  }
}
