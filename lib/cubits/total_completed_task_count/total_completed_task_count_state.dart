// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'total_completed_task_count_cubit.dart';

class TotalCompletedTaskCountState extends Equatable {
  final int totalTaskCount;

  const TotalCompletedTaskCountState({required this.totalTaskCount});

  factory TotalCompletedTaskCountState.initial() {
    return const TotalCompletedTaskCountState(totalTaskCount: 0);
  }

  @override
  List<Object> get props => [totalTaskCount];

  @override
  bool get stringify => true;

  TotalCompletedTaskCountState copyWith({
    int? totalTaskCount,
  }) {
    return TotalCompletedTaskCountState(
      totalTaskCount: totalTaskCount ?? this.totalTaskCount,
    );
  }
}
