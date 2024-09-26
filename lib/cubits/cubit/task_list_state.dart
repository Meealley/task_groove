part of 'task_list_cubit.dart';

sealed class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object> get props => [];
}

final class TaskListInitial extends TaskListState {}
