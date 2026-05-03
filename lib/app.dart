import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'bindings/app_binding.dart';
import 'core/localization/app_translations.dart';
import 'core/storage/storage_keys.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/utils/app_size_class.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Use StorageService instead of bypassing it with raw GetStorage reads
    final storage = Get.find<StorageService>();
    final themePref = storage.getTheme() ?? 'system';
    final langPref = storage.getLanguage() ?? 'en';

    final initialTheme = switch (themePref) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };

    final initialLocale = switch (langPref) {
      StorageKeys.langCodeAr => const Locale('ar', 'SA'),
      StorageKeys.langCodeBn => const Locale('bn', 'BD'),
      _ => const Locale('en', 'US'),
    };

    // ✅ Use a universal design size that works well across all screen sizes.
    // ScreenUtil will scale from this baseline to match any device.
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 baseline
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true, // Required for DevicePreview to work correctly
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Premium Template',
          theme: lightThemeData(),
          darkTheme: darkThemeData(),
          themeMode: initialTheme,
          translations: AppTranslations(),
          locale: DevicePreview.locale(context) ?? initialLocale,
          fallbackLocale: const Locale('en', 'US'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'SA'),
            Locale('bn', 'BD'),
          ],
          // ✅ DevicePreview builder must wrap the navigator to apply device
          // frame, media query overrides and locale injection correctly.
          builder: (context, child) {
            // 1. Let DevicePreview inject its MediaQuery overrides
            final previewChild = DevicePreview.appBuilder(context, child);
            // 2. Re-initialise AppSizeClass after DevicePreview has overridden MediaQuery
            AppSizeClass.init(context);
            return previewChild;
          },
          initialBinding: AppBinding(),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
