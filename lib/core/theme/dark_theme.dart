import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

ThemeData darkThemeData() {
  const colors = AppColorScheme.dark;

  final base = ThemeData.dark(useMaterial3: true);

  return base.copyWith(
    brightness: Brightness.dark,
    primaryColor: colors.primary,
    scaffoldBackgroundColor: colors.background,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryVariantDark,
      secondary: AppColors.secondaryDark,
      secondaryContainer: AppColors.secondaryVariantDark,
      error: AppColors.errorDark,
      surface: AppColors.surfaceDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: colors.appBar,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: AppDimensions.fontXL,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      iconTheme: IconThemeData(color: colors.textPrimary),
    ),

    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: BorderSide(color: colors.border, width: AppDimensions.borderWidthThin),
      ),
      margin: EdgeInsets.zero,
    ),

    dividerTheme: DividerThemeData(
      color: colors.divider,
      thickness: AppDimensions.borderWidthMedium,
      space: 0,
    ),

    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        color: colors.textPrimary,
        fontSize: AppDimensions.fontDisplay,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.inter(
        color: colors.textPrimary,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.inter(
        color: colors.textPrimary,
        fontSize: AppDimensions.fontXXL,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        color: colors.textPrimary,
        fontSize: AppDimensions.fontL,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.inter(
        color: colors.textPrimary,
        fontSize: AppDimensions.fontL,
      ),
      bodyMedium: GoogleFonts.inter(
        color: colors.textSecondary,
        fontSize: AppDimensions.fontS,
      ),
      bodySmall: GoogleFonts.inter(
        color: colors.textHint,
        fontSize: AppDimensions.fontXS,
      ),
      labelLarge: GoogleFonts.inter(
        color: colors.textPrimary,
        fontSize: AppDimensions.fontS,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: AppDimensions.fontM,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        side: BorderSide(color: colors.primary, width: AppDimensions.borderWidthThick),
        textStyle: GoogleFonts.inter(
          fontSize: AppDimensions.fontM,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: GoogleFonts.inter(
          fontSize: AppDimensions.fontS,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceVariant,
      hintStyle: GoogleFonts.inter(
        color: colors.textHint,
        fontSize: AppDimensions.fontS,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingL - 2,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(color: colors.primary, width: AppDimensions.borderWidthThick),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(color: colors.error, width: AppDimensions.borderWidthThick),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.textHint,
      elevation: 8,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.elevatedSurface,
      contentTextStyle: GoogleFonts.inter(
        color: colors.textPrimary,
        fontSize: AppDimensions.fontS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    extensions: const [AppColorScheme.dark],
  );
}
