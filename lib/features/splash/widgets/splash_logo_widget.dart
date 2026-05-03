import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/core.dart';

/// The animated logo container shown on the splash screen.
class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = getValue<double>(
      mobile: AppDimensions.logoSizeMedium,
      tablet: 160,
      desktop: 200,
    );

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL.r),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: AppDimensions.radiusXXL,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.rocket_launch_rounded,
        size: 60.r,
        color: Colors.white,
      ),
    );
  }
}
