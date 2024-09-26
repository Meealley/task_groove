import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'search_task_state.dart';

class SearchTaskCubit extends Cubit<SearchTaskState> {
  final TaskRepository taskRepository;
  SearchTaskCubit({required this.taskRepository})
      : super(SearchTaskState.initial());

  Future<void> searchTasks(String searchTerm) async {
    emit(state.copyWith(isLoading: true));

    try {
      List<TaskModel> searhedTasks =
          await taskRepository.searchTasks(searchTerm);

      emit(state.copyWith(searchTasks: searhedTasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: CustomError(message: e.toString())));
    }
  }
}
