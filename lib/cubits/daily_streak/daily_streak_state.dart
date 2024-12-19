// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'daily_streak_cubit.dart';

class DailyStreakState extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? streakStartDate;
  final DateTime? streakEndDate;
  final DateTime? lastTaskDate;

  const DailyStreakState(
      {required this.currentStreak,
      required this.longestStreak,
      required this.streakStartDate,
      required this.streakEndDate,
      required this.lastTaskDate});

  factory DailyStreakState.initial() {
    return const DailyStreakState(
        currentStreak: 0,
        longestStreak: 0,
        streakEndDate: null,
        streakStartDate: null,
        lastTaskDate: null);
  }

  @override
  List<Object?> get props {
    return [
      currentStreak,
      longestStreak,
      streakStartDate,
      streakEndDate,
      lastTaskDate,
    ];
  }

  @override
  bool get stringify => true;

  DailyStreakState copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? streakStartDate,
    DateTime? streakEndDate,
    DateTime? lastTaskDate,
  }) {
    return DailyStreakState(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      streakStartDate: streakStartDate ?? this.streakStartDate,
      streakEndDate: streakEndDate ?? this.streakEndDate,
      lastTaskDate: lastTaskDate ?? this.lastTaskDate,
    );
  }
}
