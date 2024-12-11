part of 'completed_task_per_day_cubit.dart';

class CompletedTaskPerDayState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? message;
  final Map<DateTime, int> tasksPerDay;

  const CompletedTaskPerDayState({
    required this.isLoading,
    required this.hasError,
    this.message,
    required this.tasksPerDay,
  });

  factory CompletedTaskPerDayState.initial() {
    return const CompletedTaskPerDayState(
      isLoading: false,
      hasError: false,
      message: null,
      tasksPerDay: {},
    );
  }

  CompletedTaskPerDayState copyWith({
    bool? isLoading,
    bool? hasError,
    String? message,
    Map<DateTime, int>? tasksPerDay,
  }) {
    return CompletedTaskPerDayState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      message: message ?? this.message,
      tasksPerDay: tasksPerDay ?? this.tasksPerDay,
    );
  }

  @override
  List<Object?> get props => [isLoading, hasError, message, tasksPerDay];
}
