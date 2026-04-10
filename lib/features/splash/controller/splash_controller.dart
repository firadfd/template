import 'package:get/get.dart';
import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Standard delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 3));

    final String? token = await _storageService.getAccessToken();
    final bool hasOnboarded = _storageService.hasOnboarded();

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      if (hasOnboarded) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    }
  }
}
