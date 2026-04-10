import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:file_uploader/features/auth/login/view/login_screen.dart';
import 'package:file_uploader/features/auth/login/controller/login_controller.dart';
import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/features/auth/repository/auth_repository.dart';
import 'package:file_uploader/core/utils/app_size_class.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockStorageService mockStorageService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockStorageService = MockStorageService();

    Get.reset();
    
    Get.put<AuthRepository>(mockAuthRepository);
    Get.put<StorageService>(mockStorageService);
    Get.put(LoginController());
  });

  Widget createWidgetUnderTest() {
    return GetMaterialApp(
      home: const LoginScreen(),
      builder: (context, child) {
        // Initialize SizeClass for tests to avoid assertion errors
        AppSizeClass.init(context);
        return child!;
      },
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all initial UI elements', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Allow GetX and animations to settle

      // Find by TextFormField since CustomTextField wraps it
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
