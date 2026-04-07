import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/routes/app_routes.dart';

class LoginController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "login_error".tr,
        "fill_fields".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    await _storageService.saveTokens(
      accessToken: "example_access_token",
      refreshToken: "example_refresh_token",
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
