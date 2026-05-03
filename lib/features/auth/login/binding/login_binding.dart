import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../../repository/auth_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
