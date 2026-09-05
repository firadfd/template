import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:template/core/storage/storage_service.dart';
import 'package:template/core/utils/app_size_class.dart';
import 'package:template/features/auth/login/controller/login_controller.dart';
import 'package:template/features/auth/login/view/login_screen.dart';
import 'package:template/features/auth/repository/auth_repository.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockStorageService mockStorageService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockStorageService = MockStorageService();

    Get.testMode = true;
    Get.reset();

    Get.put<AuthRepository>(mockAuthRepository);
    Get.put<StorageService>(mockStorageService);
    Get.put(LoginController());
  });

  tearDown(Get.reset);

  // The screen uses flutter_screenutil extensions (.h/.w/.sp), which throw a
  // LateInitializationError unless ScreenUtil has been initialized. Wrapping in
  // ScreenUtilInit mirrors what MyApp does in production.
  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        home: const LoginScreen(),
        builder: (context, child) {
          AppSizeClass.init(context);
          return child!;
        },
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders both input fields and the submit button', (
      tester,
    ) async {
      await _usePhoneViewport(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('typing updates the controllers', (tester) async {
      await _usePhoneViewport(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final controller = Get.find<LoginController>();
      await tester.enterText(
        find.byType(TextFormField).first,
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'hunter2');

      expect(controller.emailController.text, 'user@example.com');
      expect(controller.passwordController.text, 'hunter2');
    });
  });
}

/// The default 800x600 test surface is a tablet, which is not what these
/// screens are designed against. Pin a phone viewport so layout assertions
/// reflect the primary target.
Future<void> _usePhoneViewport(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1125, 2436);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
