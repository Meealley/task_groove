// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'completed_task_per_week_cubit.dart';

class CompletedTaskPerWeekState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? message;
  final Map<int, int> tasksPerWeek;

  const CompletedTaskPerWeekState(
      {required this.isLoading,
      required this.hasError,
      this.message,
      required this.tasksPerWeek});

  factory CompletedTaskPerWeekState.initial() {
    return const CompletedTaskPerWeekState(
      isLoading: false,
      hasError: false,
      message: null,
      tasksPerWeek: {},
    );
  }

  @override
  List<Object?> get props => [isLoading, hasError, message, tasksPerWeek];

  @override
  bool get stringify => true;

  CompletedTaskPerWeekState copyWith({
    bool? isLoading,
    bool? hasError,
    String? message,
    Map<int, int>? tasksPerWeek,
  }) {
    return CompletedTaskPerWeekState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      message: message ?? this.message,
      tasksPerWeek: tasksPerWeek ?? this.tasksPerWeek,
    );
  }
}
