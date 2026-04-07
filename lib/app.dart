import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/app_binding.dart';
import 'core/localization/app_translations.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/utils/app_size_class.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final String themePref = box.read('theme_mode') ?? 'system';
    final String langPref = box.read('lang_code') ?? 'en';

    ThemeMode initialTheme;
    if (themePref == 'dark') {
      initialTheme = ThemeMode.dark;
    } else if (themePref == 'light') {
      initialTheme = ThemeMode.light;
    } else {
      initialTheme = ThemeMode.system;
    }

    Locale initialLocale = const Locale('en', 'US');
    if (langPref == 'ar') initialLocale = const Locale('ar', 'SA');
    if (langPref == 'bn') initialLocale = const Locale('bn', 'BD');

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
      // Initializing the responsive system. 
      // Builder ensures context has MediaQuery data and recalculates on screen resize/orientation.
      builder: (context, child) {
        AppSizeClass.init(context);
        return EasyLoading.init()(context, child);
      },
    );
  }
}
