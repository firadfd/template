import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import 'package:file_uploader/core/utils/app_size_class.dart';
import 'package:file_uploader/core/theme/app_colors.dart';
import 'package:file_uploader/core/widgets/custom_button.dart';
import 'package:file_uploader/core/widgets/custom_text.dart';
import 'package:file_uploader/core/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Finding the globally bound controller
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
                text: "welcome_back".tr,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: getHeight(8)),
              CustomText(
                text: "login_to_continue".tr,
                fontSize: 16,
                color: context.appColors.textSecondary,
              ),
              SizedBox(height: getHeight(48)),
              CustomTextField(
                controller: controller.emailController,
                hintText: "email_hint".tr,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: getHeight(16)),
              CustomTextField(
                controller: controller.passwordController,
                hintText: "password_hint".tr,
                isPassword: true,
              ),
              SizedBox(height: getHeight(32)),
              Obx(() => CustomButton(
                text: "login".tr,
                isLoading: controller.isLoading.value,
                onPressed: controller.login,
              )),
              SizedBox(height: getHeight(24)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "no_account".tr,
                      color: context.appColors.textSecondary,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("sign_up".tr),
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
