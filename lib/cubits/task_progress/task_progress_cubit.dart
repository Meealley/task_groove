import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';

part 'task_progress_state.dart';

class TaskProgressCubit extends Cubit<TaskProgressState> {
  final TaskListCubit taskListCubit;
  late StreamSubscription taskListSubscription;

  TaskProgressCubit({required this.taskListCubit})
      : super(TaskProgressState.initial()) {
    _initialize();
  }

  void _initialize() {
    taskListSubscription = taskListCubit.stream.listen(
      (TaskListState taskListState) {
        //calculate total number of completed tasks
        final totalTasks = taskListState.tasks.length;
        final completedTasks = _calculateCompletedTasks(taskListState.tasks);

        // calculate percentage
        final percentCompleted =
            totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

        emit(
          state.copyWith(
            totalTask: totalTasks,
            completedTask: completedTasks,
            percentCompleted: percentCompleted,
          ),
        );
      },
    );
  }

  int _calculateCompletedTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.completed).length;
  }

  @override
  Future<void> close() {
    taskListSubscription.cancel();
    return super.close();
  }
}
