import 'dart:developer';

import 'package:bloc/bloc.dart';
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
      await fetchTasks();
    } catch (e) {
      emit(state.copyWith(
        status: TaskListStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }
}
