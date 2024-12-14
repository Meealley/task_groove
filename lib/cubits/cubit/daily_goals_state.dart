// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'daily_goals_cubit.dart';

class DailyGoalsState extends Equatable {
  final int completedTasks;
  final int totalTasks;

  const DailyGoalsState(
      {required this.completedTasks, required this.totalTasks});

  factory DailyGoalsState.initial() {
    return const DailyGoalsState(totalTasks: 0, completedTasks: 0);
  }

  @override
  List<Object> get props => [completedTasks, totalTasks];

  @override
  bool get stringify => true;

  DailyGoalsState copyWith({
    int? completedTasks,
    int? totalTasks,
  }) {
    return DailyGoalsState(
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }
}
