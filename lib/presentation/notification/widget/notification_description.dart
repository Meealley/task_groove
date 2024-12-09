import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/truncate_text.dart';

class NotificationDescriptionScreen extends StatelessWidget {
  final String title;
  final String message;
  final String? imageUrl;

  const NotificationDescriptionScreen({
    super.key,
    required this.title,
    required this.message,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
// Determine the image based on the title
    String imagePath =
        "assets/images/welcome_notification.png"; // Default image
    if (title.startsWith("Welcome")) {
      imagePath = "assets/images/welcome_notification.png";
    } else if (title.startsWith("Task")) {
      imagePath = "assets/images/task_reminder.png";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          truncateText(title, 28),
          style: AppTextStyles.bodyTextLg,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Allow scrolling for longer content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imagePath),
              const SizedBox(height: 16.0),
              // Displaying the notification message
              Text(
                message,
                style: AppTextStyles.bodySmall,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                title,
                style: AppTextStyles.bodyTextBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
