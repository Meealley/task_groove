import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/presentation/bottom_navbar/widgets/bottom_nav_widgets.dart';
import 'package:task_groove/presentation/home/home_screen.dart';
import 'package:task_groove/presentation/notification/widget/notification_screen.dart';
import 'package:task_groove/presentation/profile/profile_screen.dart';
import 'package:task_groove/presentation/search/search_screen.dart';
import 'package:task_groove/theme/app_textstyle.dart';
// import 'package:task_groove/theme/appcolors.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';

class BottomNavigationUserBar extends StatefulWidget {
  const BottomNavigationUserBar({super.key});

  @override
  State<BottomNavigationUserBar> createState() =>
      _BottomNavigationUserBarState();
}

class _BottomNavigationUserBarState extends State<BottomNavigationUserBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    // _trackAppUsage();
  }

  // Function to fetch unread notification count
  Stream<int> _fetchUnreadNotificationCount() {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    return firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isOpened', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const SearchScreen(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(
      int unreadCount, Color themeColor) {
    return [
      PersistentBottomNavBarItem(
        contentPadding: 10.h,
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            FontAwesomeIcons.house,
            size: 17.sp,
          ),
        ),
        activeColorPrimary: themeColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 17.sp,
          ),
        ),
        activeColorPrimary: themeColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: badges.Badge(
            showBadge: unreadCount > 0,
            badgeContent: Text(
              unreadCount.toString(),
              style: AppTextStyles.bodySmall,
            ),
            child: FaIcon(
              FontAwesomeIcons.bell,
              size: 17.sp,
            ),
          ),
        ),
        activeColorPrimary: themeColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            FontAwesomeIcons.user,
            size: 17.sp,
          ),
        ),
        activeColorPrimary: themeColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        Color themeColor = themeState.color;
        return StreamBuilder<int>(
          stream: _fetchUnreadNotificationCount(),
          builder: (context, snapshot) {
            int unreadCount = snapshot.data ?? 0;
            return BottomNavWidgets(
              controller: _controller,
              buildScreens: _buildScreens(),
              navBarItems: _navBarsItems(unreadCount, themeColor),
            );
          },
        );
      },
    );
  }
}
