import 'package:file_uploader/core/theme/app_colors.dart';
import 'package:file_uploader/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Finding the globally bound controller
    final controller = Get.find<MainController>();
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return CustomText(
                text: 'home_title'.tr,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              );
            case 1:
              return CustomText(
                text: 'tab_profile'.tr,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              );
            default:
              return CustomText(
                text: 'app_name'.tr,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              );
          }
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
              label: 'tab_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded),
              label: 'tab_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded),
              label: 'tab_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded),
              label: 'tab_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: 'tab_profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
