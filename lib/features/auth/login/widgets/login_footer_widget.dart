import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';

/// The "Don't have an account? Sign Up" footer.
///
/// Uses [Wrap] rather than [Row] so the label and action reflow onto two lines
/// on narrow viewports or at large text scales instead of overflowing.
class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CustomText(text: AppStrings.noAccount.tr, color: colors.textSecondary),
        TextButton(onPressed: () {}, child: Text(AppStrings.signUp.tr)),
      ],
    );
  }
}
