import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DailyStreakModel extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? streakStartDate;
  final DateTime? streakEndDate;
  final DateTime? lastTaskDate;
  const DailyStreakModel({
    required this.currentStreak,
    required this.longestStreak,
    this.streakStartDate,
    this.streakEndDate,
    this.lastTaskDate,
  });

  factory DailyStreakModel.fromMap(Map<String, dynamic> map) {
    return DailyStreakModel(
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      streakStartDate: (map['streakStartDate'] as Timestamp?)?.toDate(),
      streakEndDate: (map['streakEndDate'] as Timestamp?)?.toDate(),
      lastTaskDate: (map['lastTaskDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'streakStartDate': streakStartDate,
      'streakEndDate': streakEndDate,
      'lastTaskDate': lastTaskDate,
    };
  }

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        streakStartDate,
        streakEndDate,
        lastTaskDate,
      ];
}
