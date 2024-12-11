import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/repository/task_repository.dart';

part 'completed_task_per_day_state.dart';

class CompletedTaskPerDayCubit extends Cubit<CompletedTaskPerDayState> {
  final TaskRepository taskRepository;

  CompletedTaskPerDayCubit({required this.taskRepository})
      : super(CompletedTaskPerDayState.initial());

  // Fetch and calculate the completed tasks per day
  Future<void> fetchCompletedTasksPerDay() async {
    try {
      emit(state.copyWith(isLoading: true, hasError: false, message: null));

      // Fetch all tasks from the repository
      List<TaskModel> tasks = await taskRepository.fetchTasks();

      // Filter completed tasks and group them by day
      Map<DateTime, int> completedTasksPerDay = {};

      for (TaskModel task in tasks) {
        if (task.completed && task.stopDateTime != null) {
          DateTime completionDate = DateTime(
            task.stopDateTime!.year,
            task.stopDateTime!.month,
            task.stopDateTime!.day,
          );

          if (completedTasksPerDay.containsKey(completionDate)) {
            completedTasksPerDay[completionDate] =
                completedTasksPerDay[completionDate]! + 1;
          } else {
            completedTasksPerDay[completionDate] = 1;
          }
        }
      }

      // Sort the map by date
      final sortedMap = Map.fromEntries(
        completedTasksPerDay.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)),
      );

      // Emit the success state with the sorted map
      emit(state.copyWith(
        completedTasksPerDay: sortedMap,
        isLoading: false,
        hasError: false,
        message: 'Completed tasks loaded successfully',
      ));
    } catch (e) {
      // Handle errors and emit the error state
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        message: e.toString(),
      ));
    }
  }
}
