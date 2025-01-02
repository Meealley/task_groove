import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/groove_level/groove_level_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class GrooveLevels extends StatefulWidget {
  const GrooveLevels({super.key});

  @override
  State<GrooveLevels> createState() => _GrooveLevelsState();
}

class _GrooveLevelsState extends State<GrooveLevels> {
  final List<Map<String, dynamic>> grooveLevels = [
    {"name": "Trailblazer", "points": 0, "icon": FontAwesomeIcons.fire},
    {"name": "Seedling", "points": 400, "icon": FontAwesomeIcons.seedling},
    {"name": "Pathfinder", "points": 800, "icon": FontAwesomeIcons.compass},
    {"name": "Craftsman", "points": 1200, "icon": FontAwesomeIcons.hammer},
    {"name": "Virtuoso", "points": 2000, "icon": FontAwesomeIcons.palette},
    {"name": "Savant", "points": 7299, "icon": FontAwesomeIcons.book},
    {"name": "Luminary", "points": 20999, "icon": FontAwesomeIcons.star},
  ];

  @override
  void initState() {
    super.initState();
    context.read<GrooveLevelCubit>().loadGroovelevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Groove Levels",
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<GrooveLevelCubit, GrooveLevelState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!.message));
          }

          return Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              children: [
                _buildCurrentLevelHeader(state),
                SizedBox(height: 2.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: grooveLevels.length,
                    itemBuilder: (context, index) {
                      final level = grooveLevels[index];
                      final isCurrentLevel = state.level == level["name"];
                      return ListTile(
                        leading: FaIcon(
                          level["icon"],
                          color: isCurrentLevel ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          level["name"],
                          style: AppTextStyles.bodyText.copyWith(
                            fontSize: 24,
                            fontWeight: isCurrentLevel
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCurrentLevel ? Colors.green : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "Points: ${level['points']}",
                          style: AppTextStyles.bodySmall,
                        ),
                        trailing: isCurrentLevel
                            ? const Icon(
                                FontAwesomeIcons.checkCircle,
                                color: Colors.green,
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentLevelHeader(GrooveLevelState state) {
    final currentLevel = grooveLevels.firstWhere(
      (level) => level["name"] == state.level,
      orElse: () =>
          {"name": "Unknown", "icon": FontAwesomeIcons.questionCircle},
    );

    final nextLevel = grooveLevels.firstWhere(
      (level) => level["points"] > state.points,
      orElse: () => {"name": "Max Level", "points": state.points},
    );

    final progressToNextLevel = state.points /
        (nextLevel["points"] > state.points
            ? nextLevel["points"]
            : state.points);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.level,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 0.3.h),
            Text(
              "${nextLevel['points'] - state.points} points to reach ${nextLevel['name']}",
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(height: 1.h),
            Text(
              "Current Groove Level Points: ${state.points}",
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        CircularPercentIndicator(
          radius: 40,
          lineWidth: 6.0,
          percent: progressToNextLevel.clamp(0.0, 1.0),
          center: FaIcon(
            currentLevel["icon"],
            size: 40,
            color: Colors.grey,
          ),
          progressColor: Colors.green,
        ),
      ],
    );
  }
}
