import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:file_uploader/core/core.dart';

/// The email + password input fields section.
class LoginFormWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          hintText: AppStrings.emailHint.tr,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: AppDimensions.spaceL.h),
        CustomTextField(
          controller: passwordController,
          hintText: AppStrings.passwordHint.tr,
          isPassword: true,
        ),
      ],
    );
  }
}
