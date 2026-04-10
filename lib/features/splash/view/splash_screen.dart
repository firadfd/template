import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/core.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: getRadius(AppDimensions.logoSizeMedium),
              height: getRadius(AppDimensions.logoSizeMedium),
              decoration: BoxDecoration(
                gradient: context.appColors.primaryGradient,
                borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusXXL)),
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.primary.withValues(alpha: 0.3),
                    blurRadius: AppDimensions.radiusXXL,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.rocket_launch_rounded,
                size: getRadius(60),
                color: Colors.white,
              ),
            ),
            SizedBox(height: getHeight(AppDimensions.spaceXXL)),
            CustomText(
              text: AppStrings.appName.tr,
              fontSize: AppDimensions.fontXXXL,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: getHeight(AppDimensions.spaceS)),
            CustomText(
              text: AppStrings.appTagline.tr,
              fontSize: AppDimensions.fontS,
              color: context.appColors.textSecondary,
            ),
            SizedBox(height: getHeight(AppDimensions.spaceHuge)),
            SizedBox(
              width: getRadius(AppDimensions.iconXXL),
              height: getRadius(AppDimensions.iconXXL),
              child: CircularProgressIndicator(
                strokeWidth: AppDimensions.borderWidthExtraThick,
                color: context.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
