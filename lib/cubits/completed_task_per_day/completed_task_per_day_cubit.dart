import 'dart:async';
import 'dart:developer';
// import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';

part 'completed_task_per_day_state.dart';

class CompletedTaskPerDayCubit extends Cubit<CompletedTaskPerDayState> {
  final TaskListCubit taskListCubit;
  late StreamSubscription taskListSubscription;

  CompletedTaskPerDayCubit({required this.taskListCubit})
      : super(CompletedTaskPerDayState.initial()) {
    _initialize();
  }

  void _initialize() {
    emit(state.copyWith(isLoading: true));
    taskListSubscription = taskListCubit.stream.listen(
      (TaskListState taskListState) {
        try {
          final tasksPerDay = _groupCompletedTasksByDay(taskListState.tasks);
          emit(state.copyWith(
            isLoading: false,
            hasError: false,
            tasksPerDay: tasksPerDay,
          ));
        } catch (e) {
          emit(state.copyWith(
            isLoading: false,
            hasError: true,
            message: 'Error grouping tasks: $e',
          ));
        }
      },
    );
  }

  Map<DateTime, int> _groupCompletedTasksByDay(List<TaskModel> tasks) {
    final Map<DateTime, int> tasksPerDay = {};

    for (final task in tasks) {
      if (task.completed && task.completionDate != null) {
        final completionDate = _normalizeDate(task.completionDate!);

        tasksPerDay[completionDate] = (tasksPerDay[completionDate] ?? 0) + 1;
      }
    }

    return tasksPerDay;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void fetchCompletedTasksPerDay() {
    emit(state.copyWith(isLoading: true));
  }

  @override
  Future<void> close() {
    taskListSubscription.cancel();
    return super.close();
  }
}
