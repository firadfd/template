import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';
import '../controller/login_controller.dart';
import '../widgets/login_header_widget.dart';
import '../widgets/login_form_widget.dart';
import '../widgets/login_footer_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    // On tablet/desktop: constrain the form to a card-like column
    final maxWidth = getValue<double>(mobile: double.infinity, tablet: 480, desktop: 520);

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimensions.spaceHuge.h),
                const LoginHeaderWidget(),
                SizedBox(height: AppDimensions.spaceHuge.h),
                LoginFormWidget(
                  emailController: controller.emailController,
                  passwordController: controller.passwordController,
                ),
                SizedBox(height: AppDimensions.spaceXXL.h),
                Obx(() => CustomButton(
                      text: AppStrings.login.tr,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.login,
                    )),
                SizedBox(height: AppDimensions.spaceXL.h),
                const Center(child: LoginFooterWidget()),
                SizedBox(height: AppDimensions.spaceHuge.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
