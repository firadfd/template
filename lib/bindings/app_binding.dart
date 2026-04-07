import 'package:get/get.dart';
import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/core/network/network_caller.dart';

// Feature Controllers
import 'package:file_uploader/features/splash/controller/splash_controller.dart';
import 'package:file_uploader/features/onboarding/controller/onboarding_controller.dart';
import 'package:file_uploader/features/auth/login/controller/login_controller.dart';
import 'package:file_uploader/features/main/controller/main_controller.dart';
import 'package:file_uploader/features/home/controller/home_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // ─────────────── Core Global Singletons ────────────────

    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<NetworkCaller>(NetworkCaller(), permanent: true);

    // ─────────────── Feature Controllers (Lazy + Fenix) ────────────────

    // Splash
    Get.lazyPut(() => SplashController(), fenix: true);

    // Onboarding
    Get.lazyPut(() => OnboardingController(), fenix: true);

    // Login
    Get.lazyPut(() => LoginController(), fenix: true);

    // Main & Navigation
    Get.lazyPut(() => MainController(), fenix: true);

    // Home
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
