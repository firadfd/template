import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/core.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: getRadius(AppDimensions.logoSizeLarge),
              height: getRadius(AppDimensions.logoSizeLarge),
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.volunteer_activism_rounded,
                size: getRadius(100),
                color: context.appColors.primary,
              ),
            ),
            SizedBox(height: getHeight(AppDimensions.spaceHuge)),
            CustomText(
              text: AppStrings.onboardingWelcome.tr,
              fontSize: AppDimensions.fontXXXL,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(AppDimensions.spaceL)),
            CustomText(
              text: AppStrings.onboardingDesc.tr,
              fontSize: AppDimensions.fontL,
              color: context.appColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getHeight(AppDimensions.spaceMassive)),
            CustomButton(
              text: AppStrings.getStarted.tr,
              onPressed: controller.completeOnboarding,
            ),
          ],
        ),
      ),
    );
  }
}
