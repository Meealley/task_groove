// import 'dart:core';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

class BottomNavWidgets extends StatelessWidget {
  final PersistentTabController controller;
  final List<Widget> buildScreens;
  final List<PersistentBottomNavBarItem> navBarItems;

  const BottomNavWidgets(
      {super.key,
      required this.controller,
      required this.buildScreens,
      required this.navBarItems});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      // margin: const EdgeInsets.all(20),
      context,
      controller: controller,
      screens: buildScreens,
      items: navBarItems,
      // confineInSafeArea: true,
      confineToSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 100),
          curve: Curves.ease,
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
        ),
      ),
      navBarStyle: NavBarStyle.style13,
      navBarHeight: 5.h,
    );
  }
}
