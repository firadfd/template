import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';

/// The fd name + tagline text block on the splash screen.
class SplashTextWidget extends StatelessWidget {
  const SplashTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        CustomText(
          text: AppStrings.appName.tr,
          fontSize: getValue<double>(
            mobile: AppDimensions.fontXXXL,
            tablet: 28,
            desktop: 36,
          ),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: AppDimensions.spaceS.h),
        CustomText(
          text: AppStrings.appTagline.tr,
          fontSize: getValue<double>(
            mobile: AppDimensions.fontS,
            tablet: AppDimensions.fontM,
            desktop: AppDimensions.fontL,
          ),
          color: colors.textSecondary,
        ),
      ],
    );
  }
}
