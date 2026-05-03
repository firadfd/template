import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'core/storage/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([]);

  Get.put<StorageService>(StorageService(), permanent: true);

  runApp(
    DevicePreview(
      // Set to false in production; true during development to preview layouts.
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}
