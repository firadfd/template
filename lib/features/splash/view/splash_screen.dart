import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import '../controller/splash_controller.dart';
import '../widgets/splash_loader_widget.dart';
import '../widgets/splash_logo_widget.dart';
import '../widgets/splash_text_widget.dart';

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
            const SplashLogoWidget(),
            SizedBox(height: AppDimensions.spaceXXL.h),
            const SplashTextWidget(),
            SizedBox(height: AppDimensions.spaceHuge.h),
            const SplashLoaderWidget(),
          ],
        ),
      ),
    );
  }
}
