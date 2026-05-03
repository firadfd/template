import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

/// The headline + description copy block on the onboarding screen.
class OnboardingTextWidget extends StatelessWidget {
  const OnboardingTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final titleSize = getValue<double>(
      mobile: AppDimensions.fontXXXL,
      tablet: 28,
      desktop: 36,
    );
    final bodySize = getValue<double>(
      mobile: AppDimensions.fontL,
      tablet: AppDimensions.fontXL,
      desktop: AppDimensions.fontXXL,
    );

    return Column(
      children: [
        CustomText(
          text: AppStrings.onboardingWelcome.tr,
          fontSize: titleSize,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceL.h),
        CustomText(
          text: AppStrings.onboardingDesc.tr,
          fontSize: bodySize,
          color: colors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
