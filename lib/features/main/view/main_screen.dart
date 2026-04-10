import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/core.dart';
import '../controller/main_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Obx(() {
          final title = switch (controller.currentIndex.value) {
            0 => AppStrings.homeTitle.tr,
            1 => AppStrings.tabProfile.tr,
            _ => AppStrings.appName.tr,
          };
          return CustomText(
            text: title,
            fontSize: AppDimensions.fontXXL,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          );
        }),
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: colors.primary,
          unselectedItemColor: colors.textHint,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded),
              label: AppStrings.tabHome.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded),
              label: AppStrings.tabHome.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded),
              label: AppStrings.tabHome.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded),
              label: AppStrings.tabHome.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: AppStrings.tabProfile.tr,
            ),
          ],
        ),
      ),
    );
  }
}
