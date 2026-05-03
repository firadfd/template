import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';

/// The large circle icon displayed at the top of the onboarding screen.
class OnboardingIllustrationWidget extends StatelessWidget {
  const OnboardingIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = getValue<double>(
      mobile: AppDimensions.logoSizeLarge,
      tablet: 240,
      desktop: 300,
    );
    final iconSize = getValue<double>(mobile: 100, tablet: 120, desktop: 150);

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.volunteer_activism_rounded,
        size: iconSize.r,
        color: colors.primary,
      ),
    );
  }
}
