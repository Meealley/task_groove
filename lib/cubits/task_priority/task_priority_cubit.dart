// import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'task_priority_state.dart';

class TaskPriorityCubit extends Cubit<TaskPriorityState> {
  final TaskRepository taskRepository;
  TaskPriorityCubit({required this.taskRepository})
      : super(TaskPriorityState.initial());

  Future<void> fetchTaskByPriority() async {
    emit(state.copyWith(isLoading: true));

    try {
      final sortedPriority = await taskRepository.sortTasksByPriority();
      emit(state.copyWith(tasks: sortedPriority, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: CustomError(message: e.toString())));
    }
  }
}
