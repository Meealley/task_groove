part of 'search_task_cubit.dart';

class SearchTaskState extends Equatable {
  final List<TaskModel> searchTasks;
  final CustomError? error;
  final bool isLoading;

  const SearchTaskState(
      {required this.searchTasks, this.error, required this.isLoading});

  factory SearchTaskState.initial() {
    return const SearchTaskState(
      searchTasks: [],
      isLoading: false,
      error: CustomError(),
    );
  }

  @override
  List<Object?> get props => [searchTasks, error, isLoading];

  @override
  bool get stringify => true;

  SearchTaskState copyWith({
    List<TaskModel>? searchTasks,
    CustomError? error,
    bool? isLoading,
  }) {
    return SearchTaskState(
      searchTasks: searchTasks ?? this.searchTasks,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
