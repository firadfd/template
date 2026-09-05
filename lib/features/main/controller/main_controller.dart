import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import '../../profile/view/profile_screen.dart';

class MainController extends GetxController {
  /// Current bottom-navigation / rail index.
  final currentIndex = 0.obs;

  /// Tab destinations. Swap each [PlaceholderView] for your own feature screen;
  /// keep this list in the same order as the items in [MainBottomNavBar] and
  /// [MainNavigationRail].
  final List<Widget> screens = const [
    PlaceholderView(title: 'Home', icon: Icons.home_rounded),
    PlaceholderView(title: 'Explore', icon: Icons.explore_rounded),
    PlaceholderView(title: 'Alerts', icon: Icons.notifications_rounded),
    PlaceholderView(title: 'Saved', icon: Icons.bookmark_rounded),
    ProfileScreen(),
  ];

  void changeTabIndex(int index) => currentIndex.value = index;
}
