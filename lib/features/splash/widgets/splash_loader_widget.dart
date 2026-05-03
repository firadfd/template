import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/core.dart';

/// The loading indicator shown at the bottom of the splash screen.
class SplashLoaderWidget extends StatelessWidget {
  const SplashLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final indicatorSize = getValue<double>(mobile: AppDimensions.iconXXL, tablet: 48, desktop: 56);
    return SizedBox(
      width: indicatorSize.r,
      height: indicatorSize.r,
      child: CircularProgressIndicator(
        strokeWidth: AppDimensions.borderWidthExtraThick,
        color: context.appColors.primary,
      ),
    );
  }
}
