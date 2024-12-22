import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/daily_goals/daily_goals_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:confetti/confetti.dart';

class GoalBottomSheet extends StatefulWidget {
  const GoalBottomSheet({super.key});

  @override
  State<GoalBottomSheet> createState() => _GoalBottomSheetState();
}

class _GoalBottomSheetState extends State<GoalBottomSheet> {
  late ConfettiController _confettiController;
  final GlobalKey _shareKey = GlobalKey();
  bool _isCapturing = false;

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

  Future<void> _captureAndShare() async {
    try {
      setState(() {
        _isCapturing = true; // Hide the Share button and 'X' button
      });

      await Future.delayed(const Duration(milliseconds: 100));

      // Capture the widget as an image
      RenderRepaintBoundary boundary =
          _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      ui.Image capturedImage = await boundary.toImage(pixelRatio: 2.0);
      ByteData? capturedByteData =
          await capturedImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List capturedBytes = capturedByteData!.buffer.asUint8List();

      // Load app logo as an image
      final ByteData logoData =
          await rootBundle.load('assets/images/tasks.png');
      Uint8List logoBytes = logoData.buffer.asUint8List();
      ui.Codec codec =
          await ui.instantiateImageCodec(logoBytes, targetHeight: 100);
      ui.FrameInfo logoFrame = await codec.getNextFrame();
      ui.Image logoImage = logoFrame.image;

      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);

      final Paint paint = Paint();
      canvas.drawImage(capturedImage, Offset.zero, paint);

      // Draw the logo at the top-right corner
      double logoX = capturedImage.width - logoImage.width - 20;
      double logoY = 20;
      canvas.drawImage(logoImage, Offset(logoX, logoY), paint);

      // Generate final image
      ui.Image finalImage = await recorder
          .endRecording()
          .toImage(capturedImage.width, capturedImage.height);

      ByteData? finalByteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List finalBytes = finalByteData!.buffer.asUint8List();

      // Save the final image to a temporary file
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/goal_share.png';
      final file = File(imagePath);
      await file.writeAsBytes(finalBytes);

      // Share the final image
      await Share.shareXFiles([XFile(imagePath)],
          text: 'Check out my progress!');
    } catch (e) {
      print('Error capturing and sharing: $e');
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          key: _shareKey,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 9,
            ),
            child: Column(
              children: [
                Center(
                  child: !_isCapturing
                      ? Container(
                          height: 8,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )
                      : null,
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
                    Visibility(
                      visible: !_isCapturing,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.x,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    BlocBuilder<DailyGoalsCubit, DailyGoalsState>(
                      builder: (context, state) {
                        final completedTasks = state.completedTasks;
                        return Text(
                          "You've completed $completedTasks tasks",
                          style:
                              AppTextStyles.bodyTextBold.copyWith(fontSize: 25),
                        );
                      },
                    ),
                    Text(
                      "Great work achieving your goals!",
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    //  Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: !_isCapturing,
                        child: ElevatedButton.icon(
                          onPressed: !_isCapturing
                              ? _captureAndShare
                              : null, // Share button action
                          icon: const Icon(Icons.share),
                          label: Text(
                            "Share",
                            style: AppTextStyles.bodyText,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
