import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

/// The "Welcome Back" heading + sub-title shown above the login form.
class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final titleSize = getValue<double>(
      mobile: AppDimensions.fontDisplay,
      tablet: 36,
      desktop: 40,
    );
    final subtitleSize = getValue<double>(
      mobile: AppDimensions.fontL,
      tablet: AppDimensions.fontXL,
      desktop: AppDimensions.fontXXL,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppStrings.welcomeBack.tr,
          fontSize: titleSize,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: AppDimensions.spaceS.h),
        CustomText(
          text: AppStrings.loginToContinue.tr,
          fontSize: subtitleSize,
          color: colors.textSecondary,
        ),
      ],
    );
  }
}
