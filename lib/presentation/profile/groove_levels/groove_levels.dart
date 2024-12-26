import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/groove_level/groove_level_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class GrooveLevels extends StatefulWidget {
  const GrooveLevels({super.key});

  @override
  State<GrooveLevels> createState() => _GrooveLevelsState();
}

class _GrooveLevelsState extends State<GrooveLevels> {
  @override
  void initState() {
    super.initState();
    context.read<GrooveLevelCubit>().loadGroovelevel();
  }

  // TODO: COMPLEETE THE GROOVE LEVEL SCREEN

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Groove Level",
          style: AppTextStyles.bodyTextLg,
        ),
      ),
      body: BlocBuilder<GrooveLevelCubit, GrooveLevelState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.level,
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(
                          height: .3.h,
                        ),
                        Text(
                          "230 left to get to Professional",
                          style: AppTextStyles.bodySmall,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Current Groove level point is ${state.points}",
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        // GestureDetector(
                        //   // onTap: () => context.push(Pages.editGoals),
                        //   child: Text(
                        //     "Edit Goals",
                        //     style: AppTextStyles.bodySmall.copyWith(),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Stack(
                      children: [
                        Positioned(
                          child: CircularPercentIndicator(
                            progressColor: Colors.green,
                            percent: 0.4,
                            // percent: .7,
                            radius: 40,
                            center: const FaIcon(
                              FontAwesomeIcons.award,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
