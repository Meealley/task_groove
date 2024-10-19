import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Allow scrolling for longer content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying the notification image
              // imageUrl.isNotEmpty
              //     ? Image.network(
              //         imageUrl,
              //         fit: BoxFit.cover,
              //         height: 200, // Set a fixed height for the image
              //         width: double.infinity, // Full width
              //         errorBuilder: (context, error, stackTrace) {
              //           return const Center(
              //               child: Text('Image failed to load.'));
              //         },
              //       )
              //     : const SizedBox(height: 200), // Placeholder if no image

              Image.asset("assets/images/welcome_notification.png"),
              const SizedBox(height: 16.0),
              // Displaying the notification message
              Text(
                message,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
