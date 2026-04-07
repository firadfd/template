import 'package:get/get.dart';
import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Function to complete onboarding and go to Login
  Future<void> completeOnboarding() async {
    await _storageService.setOnboarded();
    Get.offAllNamed(AppRoutes.login);
  }
}
