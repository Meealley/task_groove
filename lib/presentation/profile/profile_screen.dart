import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/cubits/profile/profile_state.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Profile',
      //     style: AppTextStyles.headingBold,
      //   ),
      //   backgroundColor: AppColors.backgroundDark,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context.push(
                      Pages.profileDescription,
                      extra: {
                        'name': state.name,
                        'email': state.email,
                        'profileImageUrl': state.profileImageUrl,
                      },
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          state.profileImageUrl,
                        ), // Placeholder image or user profile pic
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.name, // Username fetched from the backend
                            style: AppTextStyles.headingBold,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.email, // Email fetched from the backend
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // _buildProgressAndStatistics(),
            // const SizedBox(height: 24),
            // _buildActivityOverview(),
            // const SizedBox(height: 24),
            // _buildSettings(),
          ],
        ),
      ),
    );
  }

  // Widget _buildProfileHeader() {
  //   return
  // }

  Widget _buildProgressAndStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Completion Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value:
              0.7, // This would represent 70% of tasks completed (fetch dynamically)
          backgroundColor: Colors.grey[300],
          color: Colors.teal,
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        const Text(
          'You have completed 70% of your tasks.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatCard(title: 'Login Streak', value: '15 Days'),
            _StatCard(title: 'Tasks Completed', value: '58'),
            _StatCard(title: 'Points', value: '1250'),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityOverview() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Completed: Design homepage UI'),
          subtitle: Text('2 hours ago'),
        ),
        ListTile(
          leading: Icon(Icons.warning, color: Colors.red),
          title: Text('Overdue: Write blog post'),
          subtitle: Text('Due 3 days ago'),
        ),
        ListTile(
          leading: Icon(Icons.event_available, color: Colors.orange),
          title: Text('Upcoming: Client meeting'),
          subtitle: Text('Due in 1 day'),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.blue),
          title: const Text('Notification Preferences'),
          onTap: () {
            // Navigate to notification settings screen
          },
        ),
        ListTile(
          leading: const Icon(Icons.color_lens, color: Colors.purple),
          title: const Text('Theme Settings'),
          onTap: () {
            // Navigate to theme settings screen
          },
        ),
        ListTile(
          leading: const Icon(Icons.language, color: Colors.orange),
          title: const Text('Language Preferences'),
          onTap: () {
            // Navigate to language settings screen
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.red),
          title: const Text('Sign Out'),
          onTap: () {
            // Implement sign-out functionality
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
