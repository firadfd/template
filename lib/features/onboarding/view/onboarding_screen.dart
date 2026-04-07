import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';
import 'package:file_uploader/core/utils/app_size_class.dart';
import 'package:file_uploader/core/theme/app_colors.dart';
import 'package:file_uploader/core/widgets/custom_button.dart';
import 'package:file_uploader/core/widgets/custom_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Finding the globally bound controller
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: getRadius(200),
              height: getRadius(200),
              decoration: BoxDecoration(
                color: context.appColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.volunteer_activism_rounded,
                size: 100,
                color: context.appColors.primary,
              ),
            ),
            SizedBox(height: getHeight(48)),
            CustomText(
              text: "onboarding_welcome".tr,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(16)),
            CustomText(
              text: "onboarding_desc".tr,
              fontSize: 16,
              color: context.appColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(64)),
            CustomButton(
              text: "get_started".tr,
              onPressed: controller.completeOnboarding,
            ),
          ],
        ),
      ),
    );
  }
}
