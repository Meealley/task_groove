import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:confetti/confetti.dart';

class GoalBottomSheet extends StatefulWidget {
  const GoalBottomSheet({super.key});

  @override
  State<GoalBottomSheet> createState() => _GoalBottomSheetState();
}

class _GoalBottomSheetState extends State<GoalBottomSheet> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 12));
    print('Playing confetti....');
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 9,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 8,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Daily Goal',
                        style: AppTextStyles.bodyGrey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('yMMMEd').format(DateTime.now()),
                        style: AppTextStyles.bodyGrey,
                      )
                    ],
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.x,
                        size: 14,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Image.asset(
                "assets/images/medal_pics.png",
                height: 140,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "🎉 Congratulations! 🎉",
                    style: AppTextStyles.bodyTextBold.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "You've completed all your daily goals!",
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Close",
                      style: AppTextStyles.bodyTextBold.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // Downward
            maxBlastForce: 3, // Stronger spread
            minBlastForce: 1, // Min spread
            emissionFrequency: 0.05, // Higher frequency for dense rain
            numberOfParticles: 20, // More particles at once
            gravity: 0.3, //
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
