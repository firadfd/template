import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/core.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppStrings.welcomeBack.tr,
                fontSize: AppDimensions.fontDisplay,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: getHeight(AppDimensions.spaceS)),
              CustomText(
                text: AppStrings.loginToContinue.tr,
                fontSize: AppDimensions.fontL,
                color: context.appColors.textSecondary,
              ),
              SizedBox(height: getHeight(AppDimensions.spaceHuge)),
              CustomTextField(
                controller: controller.emailController,
                hintText: AppStrings.emailHint.tr,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: getHeight(AppDimensions.spaceL)),
              CustomTextField(
                controller: controller.passwordController,
                hintText: AppStrings.passwordHint.tr,
                isPassword: true,
              ),
              SizedBox(height: getHeight(AppDimensions.spaceXXL)),
              Obx(() => CustomButton(
                    text: AppStrings.login.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  )),
              SizedBox(height: getHeight(AppDimensions.spaceXL)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: AppStrings.noAccount.tr,
                      color: context.appColors.textSecondary,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(AppStrings.signUp.tr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
