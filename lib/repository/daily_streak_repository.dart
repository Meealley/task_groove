import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_groove/constants/constants.dart';

class DailyStreakRepository {
  final String userId;

  DailyStreakRepository({required this.userId});

  Future<void> updateDailyStreak() async {
    try {
      final DateTime today = DateTime.now();
      final DocumentReference streakDoc = firestore
          .collection('users')
          .doc(userId)
          .collection('streaks')
          .doc('dailyStreak');

      final snapshot = await streakDoc.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final DateTime? lastTaskDate =
            (data['lastTaskDate'] as Timestamp?)?.toDate();
        int currentStreak = data['currentStreak'] ?? 0;
        int longestStreak = data['longestStreak'] ?? 0;
        DateTime? longestStreakStartDate =
            (data['longestStreakStartDate'] as Timestamp?)?.toDate();
        DateTime? longestStreakEndDate =
            (data['longestStreakEndDate'] as Timestamp?)?.toDate();

        if (lastTaskDate == null || !isSameDay(today, lastTaskDate)) {
          if (lastTaskDate != null && isYesterday(today, lastTaskDate)) {
            // Continue the streak
            currentStreak++;
          } else {
            // Streak is broken; reset
            currentStreak = 1;
          }

          // Update longest streak if needed
          if (currentStreak > longestStreak) {
            longestStreak = currentStreak;
            longestStreakStartDate = lastTaskDate ?? today;
            longestStreakEndDate = today;
          }

          // Update Firestore
          await streakDoc.set({
            'currentStreak': currentStreak,
            'longestStreak': longestStreak,
            'longestStreakStartDate': longestStreakStartDate,
            'longestStreakEndDate': longestStreakEndDate,
            'lastTaskDate': today,
          }, SetOptions(merge: true));
        }
      } else {
        // Initialize streak data
        await streakDoc.set({
          'currentStreak': 1,
          'longestStreak': 1,
          'longestStreakStartDate': today,
          'longestStreakEndDate': today,
          'lastTaskDate': today,
        });
      }
    } catch (e) {
      throw Exception('Error updating daily streak: $e');
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isYesterday(DateTime today, DateTime lastDate) {
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    return isSameDay(yesterday, lastDate);
  }
}
