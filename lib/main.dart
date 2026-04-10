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

  // ✅ Bootstrap StorageService before runApp so app.dart can resolve it
  // without bypassing the service layer with raw GetStorage reads.
  Get.put<StorageService>(StorageService(), permanent: true);

  runApp(const MyApp());
}
