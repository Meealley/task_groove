import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/daily_streak/daily_streak_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class DailyStreaks extends StatelessWidget {
  const DailyStreaks({super.key});

  String formatDate(DateTime? date) {
    if (date == null) return '---';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: BlocBuilder<DailyStreakCubit, DailyStreakState>(
        builder: (context, state) {
          final currentStreak = state.currentStreak;
          final longestStreak = state.longestStreak;
          final streakStartDate = state.streakStartDate;
          final streakEndDate = state.streakEndDate;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Streaks',
                style: AppTextStyles.bodyGrey,
              ),
              SizedBox(
                height: .3.h,
              ),
              Text(
                '$currentStreak day${currentStreak == 1 ? "" : 's'} 🔥',
                style: AppTextStyles.bodyText,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    longestStreak > 0
                        ? 'Longest: $longestStreak day${currentStreak == 1 ? "" : 's'} (${formatDate(streakStartDate)} - ${formatDate(streakEndDate)})'
                        : 'No Streak yet!',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          );
        },
      ),
    );
  }
}
