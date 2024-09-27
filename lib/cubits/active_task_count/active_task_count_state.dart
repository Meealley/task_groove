part of 'active_task_count_cubit.dart';

class ActiveTaskCountState extends Equatable {
  final int activeTaskCount;

  const ActiveTaskCountState({required this.activeTaskCount});

  factory ActiveTaskCountState.initial() {
    return const ActiveTaskCountState(activeTaskCount: 0);
  }

  @override
  List<Object> get props => [activeTaskCount];

  @override
  bool get stringify => true;

  ActiveTaskCountState copyWith({
    int? activeTaskCount,
  }) {
    return ActiveTaskCountState(
      activeTaskCount: activeTaskCount ?? this.activeTaskCount,
    );
  }
}
