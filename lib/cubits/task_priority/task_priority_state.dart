// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'task_priority_cubit.dart';

class TaskPriorityState extends Equatable {
  final List<TaskModel> tasks;
  final bool isLoading;
  final CustomError error;

  const TaskPriorityState(
      {required this.tasks, required this.isLoading, required this.error});

  factory TaskPriorityState.initial() {
    return const TaskPriorityState(
      tasks: [],
      isLoading: false,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [tasks, isLoading, error];

  @override
  bool get stringify => true;

  TaskPriorityState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    CustomError? error,
  }) {
    return TaskPriorityState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
