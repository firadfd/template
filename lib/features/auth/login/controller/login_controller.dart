import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

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

    // NOTE: In production, replace this with a real auth endpoint via AuthRepository.
    /*
    final response = await _authRepository.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    
    if (!response.isSuccess) { 
      Get.snackbar(AppStrings.error.tr, response.errorMessage);
      isLoading.value = false;
      return; 
    }
    */

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
