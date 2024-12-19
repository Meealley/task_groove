import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_groove/repository/daily_streak_repository.dart';

part 'daily_streak_state.dart';

class DailyStreakCubit extends Cubit<DailyStreakState> {
  final DailyStreakRepository streakRepository;

  DailyStreakCubit({required this.streakRepository})
      : super(DailyStreakState.initial());

  Future<void> fetchStreakData() async {
    try {
      // emit(state.copyWith(isLoading: true));

      // Fetch streak data from Firestore
      final streakDoc = await streakRepository.getDailyStreak();
      if (streakDoc == null) {
        // If no streak data exists, emit the initial state
        emit(state.copyWith(
          // isLoading: false,
          currentStreak: 0,
          longestStreak: 0,
        ));
        return;
      }

      final currentStreak = streakDoc['currentStreak'] ?? 0;
      final longestStreak = streakDoc['longestStreak'] ?? 0;
      final streakStartDate =
          (streakDoc['longestStreakStartDate'] as Timestamp?)?.toDate();
      final streakEndDate =
          (streakDoc['longestStreakEndDate'] as Timestamp?)?.toDate();

      emit(state.copyWith(
        // isLoading: false,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        streakStartDate: streakStartDate,
        streakEndDate: streakEndDate,
      ));
    } catch (e) {
      // emit(state.copyWith(
      //   isLoading: false,
      //   hasError: true,
      //   errorMessage: e.toString(),
      // ));
      e.toString();
    }
  }
}
