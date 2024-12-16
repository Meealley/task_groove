// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'goal_celebration_cubit.dart';

class GoalCelebrationState extends Equatable {
  final bool triggerCelebration;
  final bool goalsCompleted;

  const GoalCelebrationState(
      {required this.triggerCelebration, required this.goalsCompleted});

  factory GoalCelebrationState.initial() {
    return const GoalCelebrationState(
        triggerCelebration: false, goalsCompleted: false);
  }

  @override
  List<Object> get props => [triggerCelebration, goalsCompleted];

  @override
  bool get stringify => true;

  GoalCelebrationState copyWith({
    bool? triggerCelebration,
    bool? goalsCompleted,
  }) {
    return GoalCelebrationState(
      triggerCelebration: triggerCelebration ?? this.triggerCelebration,
      goalsCompleted: goalsCompleted ?? this.goalsCompleted,
    );
  }
}
