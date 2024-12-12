import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/presentation/notification/widget/notification_description.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Function to fetch notifications for the current user
  Stream<QuerySnapshot> _fetchNotifications(String userId) {
    return firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Function to mark a notification as opened
  Future<void> _markAsOpened(String notificationId) async {
    try {
      await firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isOpened': true});
    } catch (e) {
      // Log the error or show a message to the user
      debugPrint('Error marking notification as opened: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = auth.currentUser?.uid;

    // If the user is not logged in or userId is null, show an error message
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: const Center(
          child: Text('User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications 🔔',
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        // backgroundColor: AppColors.backgroundDark,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchNotifications(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Error fetching notifications: ${snapshot.error}');
            return const Center(child: Text('Error fetching notifications'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No notifications',
              style: AppTextStyles.bodySmall,
            ));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final bool isOpened = notification['isOpened'] ?? false;

              return Dismissible(
                key: Key(notification.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    FontAwesomeIcons.trash,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
// Remove notifications from the firestore

                  try {
                    await firestore
                        .collection('notifications')
                        .doc(notification.id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Notification deleted",
                          style: AppTextStyles.bodyText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error deleting notification: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to delete notification')),
                    );
                  }
                },
                child: ListTile(
                  title: Text(
                    notification['title'] ?? 'No Title',
                    style: AppTextStyles.bodyText,
                  ),
                  subtitle: Text(
                    notification['message'] ?? 'No Message',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: FaIcon(
                    isOpened
                        ? FontAwesomeIcons.envelopeOpen
                        : FontAwesomeIcons.envelope,
                    color: isOpened ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    // Navigate to NotificationDescriptionScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDescriptionScreen(
                          title: notification['title'],
                          message: notification['message'],
                          // imageUrl: notification['imageUrl'] ??
                          //     '', // Add image URL field if it exists
                        ),
                      ),
                    );
                    _markAsOpened(
                        notification.id); // Mark as opened when tapped

                    // You can display the notification message or take other actions here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
