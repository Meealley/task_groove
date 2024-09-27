import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  final TaskRepository taskRepository;
  TaskListCubit({required this.taskRepository})
      : super(TaskListState.initial());

  // Fetch Task from TaskRepository
  Future<void> fetchTasks() async {
    emit(state.copyWith(status: TaskListStatus.loading));

    try {
      List<TaskModel> tasks = await taskRepository.fetchTasks();
      emit(state.copyWith(tasks: tasks, status: TaskListStatus.success));
      print(tasks);
    } catch (e) {
      emit(
        state.copyWith(
          error: CustomError(message: e.toString()),
          status: TaskListStatus.error,
        ),
      );
    }
  }

  // Add tasks
  Future<void> addTasks(TaskModel task) async {
    emit(state.copyWith(status: TaskListStatus.loading));
    try {
      await taskRepository.addTask(task);
      final updatedTasks = List<TaskModel>.from(state.tasks)..add(task);
      emit(state.copyWith(tasks: updatedTasks, status: TaskListStatus.success));
      log(updatedTasks.toString());
    } catch (e) {
      emit(state.copyWith(
        status: TaskListStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }

// update tasks
  Future<void> updateTasks(TaskModel task) async {
    emit(state.copyWith(status: TaskListStatus.loading));

    try {
      await taskRepository.updateTask(task);
      final updatedTasks =
          state.tasks.map((t) => t.id == task.id ? task : t).toList();
      emit(state.copyWith(
        tasks: updatedTasks,
        status: TaskListStatus.success,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskListStatus.error,
          error: CustomError(message: e.toString()),
        ),
      );
    }
  }

  // Delete Tasks
  Future<void> deleteTasks(TaskModel task) async {
    emit(state.copyWith(status: TaskListStatus.loading));

    try {
      await taskRepository.deleteTask(task);
      final updatedTasks = state.tasks.where((t) => t.id != task.id).toList();
      emit(state.copyWith(
        tasks: updatedTasks,
        status: TaskListStatus.success,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskListStatus.error,
          error: CustomError(message: e.toString()),
        ),
      );
    }
  }
}
