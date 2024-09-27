part of 'today_task_cubit.dart';

class TodayTaskState extends Equatable {
  final List<TaskModel> tasks;
  final bool isLoading;
  final CustomError? error;

  const TodayTaskState(
      {required this.tasks, required this.isLoading, required this.error});

  factory TodayTaskState.initial() {
    return const TodayTaskState(
      tasks: [],
      isLoading: false,
      error: CustomError(),
    );
  }

  @override
  List<Object?> get props => [tasks, isLoading, error];

  @override
  bool get stringify => true;

  TodayTaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    CustomError? error,
  }) {
    return TodayTaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
