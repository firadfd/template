import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    final String themePref = storage.getTheme() ?? 'system';
    final String langPref = storage.getLanguage() ?? 'en';

    final ThemeMode initialTheme = switch (themePref) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };

    final Locale initialLocale = switch (langPref) {
      StorageKeys.langCodeAr => const Locale('ar', 'SA'),
      StorageKeys.langCodeBn => const Locale('bn', 'BD'),
      _ => const Locale('en', 'US'),
    };

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Premium Template',
      theme: lightThemeData(),
      darkTheme: darkThemeData(),
      themeMode: initialTheme,
      translations: AppTranslations(),
      locale: initialLocale,
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
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      builder: (context, child) {
        AppSizeClass.init(context);
        return EasyLoading.init()(context, child);
      },
    );
  }
}
