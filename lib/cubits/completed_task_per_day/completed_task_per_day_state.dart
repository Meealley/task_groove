// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'completed_task_per_day_cubit.dart';

class CompletedTaskPerDayState extends Equatable {
  final Map<DateTime, int> completedTasksPerDay;
  final String? message;
  final bool isLoading;
  final bool hasError;

  const CompletedTaskPerDayState({
    required this.completedTasksPerDay,
    this.message,
    this.isLoading = false,
    this.hasError = false,
  });

  // Factory constructor for the initial state
  factory CompletedTaskPerDayState.initial() {
    return const CompletedTaskPerDayState(
      completedTasksPerDay: {},
      message: '',
      isLoading: false,
      hasError: false,
    );
  }

  @override
  List<Object?> get props =>
      [completedTasksPerDay, message, isLoading, hasError];

  @override
  bool get stringify => true;

  // Method to create a copy of the current state with optional changes
  CompletedTaskPerDayState copyWith({
    Map<DateTime, int>? completedTasksPerDay,
    String? message,
    bool? isLoading,
    bool? hasError,
  }) {
    return CompletedTaskPerDayState(
      completedTasksPerDay: completedTasksPerDay ?? this.completedTasksPerDay,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}
