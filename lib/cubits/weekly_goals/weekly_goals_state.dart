// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'weekly_goals_cubit.dart';

class WeeklyGoalsState extends Equatable {
  final int completedTask;
  final int totalTasks;

  const WeeklyGoalsState(
      {required this.completedTask, required this.totalTasks});

  factory WeeklyGoalsState.initial() {
    return const WeeklyGoalsState(
      completedTask: 0,
      totalTasks: 27,
    );
  }

  @override
  List<Object> get props => [completedTask, totalTasks];

  @override
  bool get stringify => true;

  WeeklyGoalsState copyWith({
    int? completedTask,
    int? totalTasks,
  }) {
    return WeeklyGoalsState(
      completedTask: completedTask ?? this.completedTask,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }
}
