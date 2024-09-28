// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/presentation/bottom_navbar/widgets/bottom_nav_widgets.dart';
import 'package:task_groove/presentation/home/home_screen.dart';
import 'package:task_groove/presentation/profile/profile_screen.dart';
import 'package:task_groove/presentation/search/search_screen.dart';
import 'package:task_groove/theme/appcolors.dart';

class BottomNavigationUserBar extends StatefulWidget {
  const BottomNavigationUserBar({super.key});

  @override
  State<BottomNavigationUserBar> createState() =>
      _BottomNavigationUserBarState();
}

class _BottomNavigationUserBarState extends State<BottomNavigationUserBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const SearchScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        // iconSize: 30,
        contentPadding: 10.h,
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            FontAwesomeIcons.house,
            size: 17.sp,
          ),
        ),
        // icon: const Icon(Icons.home),
        activeColorPrimary: AppColors.backgroundDark,
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
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            FontAwesomeIcons.personSkating,
            size: 17.sp,
          ),
        ),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavWidgets(
      controller: _controller,
      buildScreens: _buildScreens(),
      navBarItems: _navBarsItems(),
    );
  }
}
