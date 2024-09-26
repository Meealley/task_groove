part of 'task_list_cubit.dart';

class TaskListState extends Equatable {
  final List<TaskModel> tasks;
  final CustomError error;
  final TaskListStatus? status;

  const TaskListState(
      {required this.tasks, required this.error, required this.status});

  factory TaskListState.initial() {
    return const TaskListState(
      tasks: [],
      status: TaskListStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object?> get props => [tasks, error, status];

  @override
  bool get stringify => true;

  TaskListState copyWith({
    List<TaskModel>? tasks,
    CustomError? error,
    TaskListStatus? status,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}
