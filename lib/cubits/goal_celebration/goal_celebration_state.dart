// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'goal_celebration_cubit.dart';

class GoalCelebrationState extends Equatable {
  final bool triggerCelebration;

  const GoalCelebrationState({required this.triggerCelebration});

  factory GoalCelebrationState.initial() {
    return const GoalCelebrationState(triggerCelebration: false);
  }

  @override
  List<Object> get props => [triggerCelebration];

  @override
  bool get stringify => true;

  GoalCelebrationState copyWith({
    bool? triggerCelebration,
  }) {
    return GoalCelebrationState(
      triggerCelebration: triggerCelebration ?? this.triggerCelebration,
    );
  }
}
