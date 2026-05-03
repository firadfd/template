import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/onboarding_illustration_widget.dart';
import '../widgets/onboarding_text_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    final maxWidth = getValue<double>(mobile: double.infinity, tablet: 480, desktop: 560);

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const OnboardingIllustrationWidget(),
                SizedBox(height: AppDimensions.spaceHuge.h),
                const OnboardingTextWidget(),
                SizedBox(height: AppDimensions.spaceMassive.h),
                CustomButton(
                  text: AppStrings.getStarted.tr,
                  onPressed: controller.completeOnboarding,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
