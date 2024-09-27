part of 'task_progress_cubit.dart';

class TaskProgressState extends Equatable {
  final int totalTask;
  final int completedTask;
  final double percentCompleted;

  const TaskProgressState(
      {required this.totalTask,
      required this.completedTask,
      required this.percentCompleted});

  factory TaskProgressState.initial() {
    return const TaskProgressState(
      totalTask: 0,
      completedTask: 0,
      percentCompleted: 0.0,
    );
  }

  @override
  List<Object> get props => [totalTask, completedTask, percentCompleted];

  @override
  bool get stringify => true;

  TaskProgressState copyWith({
    int? totalTask,
    int? completedTask,
    double? percentCompleted,
  }) {
    return TaskProgressState(
      totalTask: totalTask ?? this.totalTask,
      completedTask: completedTask ?? this.completedTask,
      percentCompleted: percentCompleted ?? this.percentCompleted,
    );
  }
}
