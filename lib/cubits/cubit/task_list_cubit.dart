import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  TaskListCubit() : super(TaskListInitial());
}
