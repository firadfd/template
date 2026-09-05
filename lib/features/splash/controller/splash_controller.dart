import 'package:get/get.dart';
import '../../../core/storage/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 1200);

  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Long enough to avoid a jarring flash, short enough not to feel like a
    // stall. Tune or remove once you have real bootstrap work to do here.
    await Future<void>.delayed(_minimumSplashDuration);

    final token = await _storageService.getAccessToken();
    final hasOnboarded = _storageService.hasOnboarded();

    if (token != null && token.isNotEmpty) {
      await Get.offAllNamed<void>(AppRoutes.main);
    } else {
      if (hasOnboarded) {
        await Get.offAllNamed<void>(AppRoutes.login);
      } else {
        await Get.offAllNamed<void>(AppRoutes.onboarding);
      }
    }
  }
}
