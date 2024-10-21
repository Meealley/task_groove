part of 'task_list_cubit.dart';

class TaskListState extends Equatable {
  final List<TaskModel> tasks;
  final List<TaskModel>? completedTasks;
  final CustomError error;
  final TaskListStatus? status;

  const TaskListState(
      {required this.tasks,
      this.completedTasks,
      required this.error,
      required this.status});

  factory TaskListState.initial() {
    return const TaskListState(
      tasks: [],
      status: TaskListStatus.initial,
      error: CustomError(),
      completedTasks: null,
    );
  }

  @override
  List<Object?> get props => [tasks, error, status, completedTasks];

  @override
  bool get stringify => true;

  TaskListState copyWith({
    List<TaskModel>? tasks,
    List<TaskModel>? completedTasks,
    CustomError? error,
    TaskListStatus? status,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      error: error ?? this.error,
      status: status ?? this.status,
      completedTasks: completedTasks ?? completedTasks,
    );
  }
}
