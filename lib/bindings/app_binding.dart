import 'package:get/get.dart';

import 'package:file_uploader/core/network/network_caller.dart';

// Repositories
import 'package:file_uploader/features/auth/repository/auth_repository.dart';
import 'package:file_uploader/features/home/repository/home_repository.dart';

// Feature Controllers
import 'package:file_uploader/features/auth/login/controller/login_controller.dart';
import 'package:file_uploader/features/home/controller/home_controller.dart';
import 'package:file_uploader/features/main/controller/main_controller.dart';
import 'package:file_uploader/features/onboarding/controller/onboarding_controller.dart';
import 'package:file_uploader/features/splash/controller/splash_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // ─── Core Global Singletons ───────────────────────────────────────────────
    // StorageService is initialized in main.dart before runApp.
    // We skip re-registering it here to avoid duplicate registration.
    Get.put<NetworkCaller>(NetworkCaller(), permanent: true);

    // ─── Repositories (Permanent Singletons) ─────────────────────────────────
    // Repositories are stateless adapters — they never need to be recreated.
    Get.put<AuthRepository>(AuthRepository(), permanent: true);
    Get.put<HomeRepository>(HomeRepository(), permanent: true);

    // ─── Transient Controllers (fenix: true) ─────────────────────────────────
    // These screens are navigated away from and back to, so fenix allows
    // GetX to recreate them when needed without keeping them in memory.
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<OnboardingController>(() => OnboardingController(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);

    // ─── Persistent Controllers (no fenix) ───────────────────────────────────
    // These are long-lived and should NOT be rebuilt on re-navigation.
    // Using fenix on these would mask memory management issues.
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
