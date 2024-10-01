import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/models/acitvity_model.dart';
import 'package:task_groove/repository/recent_activity_repository.dart';

part 'recent_activity_state.dart';

class RecentActivityCubit extends Cubit<RecentActivityState> {
  final RecentActivityRepository recentActivityRepository;
  RecentActivityCubit({required this.recentActivityRepository})
      : super(RecentActivityState.initial());

  void fetchRecentActivity() async {
    try {
      recentActivityRepository.listenToRecentActivities().listen((activities) {
        emit(state.copyWith(recentAcitvities: activities));
      });
    } catch (e) {
      e.toString();
    }
  }

  Future<void> logActivity({
    required String taskID,
    required String action,
    required String taskTitle,
    required int pointsGained,
  }) async {
    try {
      await recentActivityRepository.logActivity(
        taskID: taskID,
        action: action,
        taskTitle: taskTitle,
        pointsGained: pointsGained,
      );
      fetchRecentActivity();
    } catch (e) {
      e.toString();
    }
  }
}
