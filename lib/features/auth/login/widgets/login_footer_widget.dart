import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

/// The "Don't have an account? Sign Up" footer row.
class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: AppStrings.noAccount.tr,
          color: colors.textSecondary,
        ),
        TextButton(
          onPressed: () {},
          child: Text(AppStrings.signUp.tr),
        ),
      ],
    );
  }
}
