import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:task_groove/models/overdue_task_status.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'overdue_task_state.dart';

class OverdueTaskCubit extends Cubit<OverdueTaskState> {
  final TaskRepository taskRepository;

  OverdueTaskCubit({required this.taskRepository})
      : super(OverdueTaskState.initial());

  // Fetch overdue task based on the startDate or stopDateTime
  Future<void> fetchOverdueTasks() async {
    emit(state.copyWith(status: OverdueTaskStatus.loading));

    try {
      final List<TaskModel> overdueTasks =
          await taskRepository.fetchOverdueTasks();
      emit(state.copyWith(
          tasks: overdueTasks, status: OverdueTaskStatus.success));
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          error: CustomError(message: e.toString()),
          status: OverdueTaskStatus.error,
        ),
      );
    }
  }

  // Delete Specific overdue task
  Future<void> deleteTask(TaskModel taskId) async {
    try {
      await taskRepository.deleteTask(taskId);

      // Remove the task from the local state
      final updatedTask =
          state.tasks.where((task) => task.id != taskId).toList();

      emit(state.copyWith(
          tasks: updatedTask, status: OverdueTaskStatus.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
        error: const CustomError(message: "Failed to delete task"),
        status: OverdueTaskStatus.error,
      ));
    }
  }
}
