import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';

part 'active_task_count_state.dart';

class ActiveTaskCountCubit extends Cubit<ActiveTaskCountState> {
  final TaskListCubit taskListCubit;
  late StreamSubscription activeTaskListSubscription;

  ActiveTaskCountCubit({required this.taskListCubit})
      : super(ActiveTaskCountState.initial()) {
    _initialize();
  }

  void _initialize() {
    activeTaskListSubscription =
        taskListCubit.stream.listen((TaskListState taskListState) {
      final activeTaskCount = _calculateActiveTasks(taskListState.tasks);
      emit(state.copyWith(activeTaskCount: activeTaskCount));
    });
  }

  int _calculateActiveTasks(List<TaskModel> tasks) {
    return tasks.where((task) => !task.completed).length;
  }

  @override
  Future<void> close() {
    activeTaskListSubscription.cancel();
    return super.close();
  }
}
