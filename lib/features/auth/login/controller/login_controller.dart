import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/core/utils/app_strings.dart';
import 'package:file_uploader/routes/app_routes.dart';
import '../../repository/auth_repository.dart';

class LoginController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        AppStrings.loginError.tr,
        AppStrings.fillFields.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // NOTE: The template uses a mock API (jsonplaceholder) which has no real auth.
    // In production, replace this with a real auth endpoint via AuthRepository.
    // final response = await _authRepository.login(
    //   email: emailController.text.trim(),
    //   password: passwordController.text,
    // );
    // if (!response.isSuccess) { ... handle error ... return; }

    // Simulated token save (replace with response.data in production)
    await Future.delayed(const Duration(seconds: 1));
    await _storageService.saveTokens(
      accessToken: 'example_access_token',
      refreshToken: 'example_refresh_token',
      expiresIn: 3600,
    );

    isLoading.value = false;
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
