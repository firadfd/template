import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';
import 'package:file_uploader/core/utils/app_size_class.dart';
import 'package:file_uploader/core/theme/app_colors.dart';
import 'package:file_uploader/core/widgets/custom_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Finding the globally bound controller
    Get.find<SplashController>();
    
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example Placeholder for App Logo
            Container(
              width: getRadius(120),
              height: getRadius(120),
              decoration: BoxDecoration(
                gradient: context.appColors.primaryGradient,
                borderRadius: BorderRadius.circular(getRadius(20)),
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: getHeight(32)),
            CustomText(
              text: "app_name".tr,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: getHeight(8)),
            CustomText(
              text: "app_tagline".tr,
              fontSize: 14,
              color: context.appColors.textSecondary,
            ),
            SizedBox(height: getHeight(48)),
            SizedBox(
              width: getWidth(40),
              height: getWidth(40),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: context.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
