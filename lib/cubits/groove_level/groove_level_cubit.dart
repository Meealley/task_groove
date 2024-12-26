import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'groove_level_state.dart';

class GrooveLevelCubit extends Cubit<GrooveLevelState> {
  final TaskRepository taskRepository;
  GrooveLevelCubit({
    required this.taskRepository,
  }) : super(GrooveLevelState.initial());

  // Current groove level
  Future<void> loadGroovelevel() async {
    emit(state.copyWith(isLoading: true));
    try {
      final points = await taskRepository.getUserPoints();
      final level = _calculateGrooveLevel(points);
      emit(
        state.copyWith(
          points: points,
          level: level,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        error: CustomError(message: e.toString()),
        isLoading: false,
      ));
    }
  }

// Update usersuser's point and recalculate the level

  Future<void> updatePoints(int additionalPoints) async {
    emit(state.copyWith(isLoading: true));

    try {
      final currentPoints = await taskRepository.getUserPoints();
      final newPoints = currentPoints + additionalPoints;

      await taskRepository.updatePoints(newPoints);
      final level = _calculateGrooveLevel(newPoints);

      emit(state.copyWith(points: newPoints, level: level, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: CustomError(
          message: e.toString(),
        ),
        isLoading: false,
      ));
    }
  }

  // Calculate the groove level based on points
  String _calculateGrooveLevel(int points) {
    if (points < 400) {
      return "Trailblazer";
    } else if (points < 800) {
      return "Seedling";
    } else if (points < 1200) {
      return 'Pathfinder';
    } else if (points < 2000) {
      return "Craftsman";
    } else if (points < 7299) {
      return "Virtuoso";
    } else if (points < 20999) {
      return "Savant";
    } else {
      return "Luminary";
    }
  }
}
