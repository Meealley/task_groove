// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'overdue_task_cubit.dart';

class OverdueTaskState extends Equatable {
  final List<TaskModel> tasks;
  final OverdueTaskStatus status;
  final CustomError error;

  const OverdueTaskState(
      {required this.tasks, required this.status, required this.error});

  factory OverdueTaskState.initial() {
    return const OverdueTaskState(
      tasks: [],
      status: OverdueTaskStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [tasks, status, error];

  @override
  bool get stringify => true;

  OverdueTaskState copyWith({
    List<TaskModel>? tasks,
    OverdueTaskStatus? status,
    CustomError? error,
  }) {
    return OverdueTaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
