part of 'goal_celebration_cubit.dart';

class GoalCelebrationState extends Equatable {
  final bool isCelebrationEnabled;
  final bool triggerCelebration;

  const GoalCelebrationState({
    required this.isCelebrationEnabled,
    required this.triggerCelebration,
  });

  factory GoalCelebrationState.initial() {
    return const GoalCelebrationState(
      isCelebrationEnabled: false,
      triggerCelebration: false,
    );
  }

  GoalCelebrationState copyWith({
    bool? isCelebrationEnabled,
    bool? triggerCelebration,
  }) {
    return GoalCelebrationState(
      isCelebrationEnabled: isCelebrationEnabled ?? this.isCelebrationEnabled,
      triggerCelebration: triggerCelebration ?? this.triggerCelebration,
    );
  }

  @override
  List<Object> get props => [isCelebrationEnabled, triggerCelebration];
}
