import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';

part 'completed_task_per_week_state.dart';

class CompletedTaskPerWeekCubit extends Cubit<CompletedTaskPerWeekState> {
  final TaskListCubit taskListCubit;
  late StreamSubscription taskListSubscription;

  CompletedTaskPerWeekCubit({required this.taskListCubit})
      : super(CompletedTaskPerWeekState.initial()) {
    _initialize();
  }

  void _initialize() {
    emit(state.copyWith(isLoading: true));
    taskListSubscription = taskListCubit.stream.listen(
      (TaskListState taskListState) {
        try {
          final tasksPerWeek = _groupCompletedTasksByWeek(taskListState.tasks);
          emit(state.copyWith(
            isLoading: false,
            hasError: false,
            tasksPerWeek: tasksPerWeek,
          ));
        } catch (e) {
          emit(
            state.copyWith(
              isLoading: false,
              hasError: true,
              message: "Error grouping tasks: $e",
            ),
          );
        }
      },
    );
  }

  Map<int, int> _groupCompletedTasksByWeek(List<TaskModel> tasks) {
    final Map<int, int> tasksPerWeek = {};

    for (final task in tasks) {
      if (task.completed && task.completionDate != null) {
        final completionWeek = _getWeekOfYear(task.completionDate!);

        tasksPerWeek[completionWeek] = (tasksPerWeek[completionWeek] ?? 0) + 1;
      }
    }
    return tasksPerWeek;
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }

  void fetchCompletedTasksPerWeek() {
    emit(state.copyWith(isLoading: true));
  }

  @override
  Future<void> close() {
    taskListSubscription.cancel();
    return super.close();
  }
}
