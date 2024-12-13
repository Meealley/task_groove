import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';

part 'total_completed_task_count_state.dart';

class TotalCompletedTaskCountCubit extends Cubit<TotalCompletedTaskCountState> {
  final TaskListCubit taskListCubit;

  late StreamSubscription taskListSubscription;

  TotalCompletedTaskCountCubit({
    required this.taskListCubit,
  }) : super(TotalCompletedTaskCountState.initial()) {
    taskListSubscription =
        taskListCubit.stream.listen((TaskListState taskListState) {
      final completedTaskCount =
          _calculateCompletedTaskCount(taskListState.tasks);
      emit(state.copyWith(totalTaskCount: completedTaskCount));
    });
  }

  // For Calculating completed task
  int _calculateCompletedTaskCount(List<TaskModel> tasks) {
    return tasks.where((task) => task.completed).length;
  }

  @override
  Future<void> close() {
    taskListSubscription.cancel();
    return super.close();
  }
}
