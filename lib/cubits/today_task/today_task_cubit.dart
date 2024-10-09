import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'today_task_state.dart';

class TodayTaskCubit extends Cubit<TodayTaskState> {
  final TaskListCubit taskListCubit;
  late StreamSubscription taskListSubscription;

  TodayTaskCubit({required this.taskListCubit})
      : super(TodayTaskState.initial()) {
    final todayTasks = _filterTodayTasks(taskListCubit.state.tasks);
    emit(state.copyWith(tasks: todayTasks, isLoading: false));
    // Directly subscribe to TaskListCubit stream in the constructor
    taskListSubscription =
        taskListCubit.stream.listen((TaskListState taskListState) {
      // Filter tasks list due today;
      final todayTasks = _filterTodayTasks(taskListState.tasks);
      emit(state.copyWith(tasks: todayTasks, isLoading: false));
    });
  }

  List<TaskModel> _filterTodayTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return tasks.where((task) {
      if (task.startDateTime != null && task.stopDateTime != null) {
        return task.stopDateTime!.isAfter(startOfDay) &&
            task.startDateTime!.isBefore(endOfDay) &&
            !task.completed;
      }

      // If only the startDateTime is set, check if it's within today
      if (task.startDateTime != null && task.stopDateTime == null) {
        return task.startDateTime!.isAfter(startOfDay) &&
            task.startDateTime!.isBefore(endOfDay) &&
            !task.completed;
      }
      return false;
    }).toList();
  }

  @override
  Future<void> close() {
    taskListSubscription.cancel(); // Cancel the stream subscription
    return super.close();
  }
}
