import 'package:flutter/material.dart';

/// Central color palette for the app.
/// Use [AppColors.light] or [AppColors.dark] depending on theme brightness.
///
/// Access via theme extension:
///   Theme.of(context).extension<AppColorScheme>()!
class AppColors {
  AppColors._();

  // ── Brand / Primary ─────────────────────────────────────────────────────────
  /// Vivid Indigo — primary brand color
  static const Color primaryLight = Color(0xFF5C6BC0);  // Indigo 400
  static const Color primaryDark  = Color(0xFF7986CB);  // Indigo 300

  static const Color primaryVariantLight = Color(0xFF3949AB); // Indigo 600
  static const Color primaryVariantDark  = Color(0xFF5C6BC0); // Indigo 400

  // ── Secondary / Accent ──────────────────────────────────────────────────────
  static const Color secondaryLight = Color(0xFF26C6DA); // Cyan 400
  static const Color secondaryDark  = Color(0xFF4DD0E1); // Cyan 300

  static const Color secondaryVariantLight = Color(0xFF00ACC1); // Cyan 600
  static const Color secondaryVariantDark  = Color(0xFF26C6DA); // Cyan 400

  // ── Backgrounds ─────────────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F6FA);
  static const Color backgroundDark  = Color(0xFF0F1117);

  // ── Surface (cards, sheets, bottom bars) ────────────────────────────────────
  static const Color surfaceLight        = Color(0xFFFFFFFF);
  static const Color surfaceDark         = Color(0xFF1A1D2B);

  static const Color surfaceVariantLight = Color(0xFFEEEFF5);
  static const Color surfaceVariantDark  = Color(0xFF252838);

  // ── Elevated surface (dialog, elevated card) ────────────────────────────────
  static const Color elevatedSurfaceLight = Color(0xFFFFFFFF);
  static const Color elevatedSurfaceDark  = Color(0xFF21253A);

  // ── AppBar ──────────────────────────────────────────────────────────────────
  static const Color appBarLight = Color(0xFF5C6BC0);
  static const Color appBarDark  = Color(0xFF1A1D2B);

  // ── Border / Divider / Outline ──────────────────────────────────────────────
  static const Color borderLight = Color(0xFFDDE0EF);
  static const Color borderDark  = Color(0xFF2E3350);

  static const Color outlineLight = Color(0xFFCFD2E2);
  static const Color outlineDark  = Color(0xFF323955);

  static const Color dividerLight = Color(0xFFE8EAEF);
  static const Color dividerDark  = Color(0xFF2A2E45);

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimaryLight   = Color(0xFF1A1D2B);
  static const Color textPrimaryDark    = Color(0xFFF0F1F7);

  static const Color textSecondaryLight = Color(0xFF5C637A);
  static const Color textSecondaryDark  = Color(0xFF9499B5);

  static const Color textHintLight      = Color(0xFFA0A4BA);
  static const Color textHintDark       = Color(0xFF60647A);

  // ── Status ───────────────────────────────────────────────────────────────────
  static const Color successLight = Color(0xFF2E7D32); // Green 800
  static const Color successDark  = Color(0xFF66BB6A); // Green 400

  static const Color warningLight = Color(0xFFF57F17); // Amber 900
  static const Color warningDark  = Color(0xFFFFCA28); // Amber 400

  static const Color errorLight   = Color(0xFFB71C1C); // Red 900
  static const Color errorDark    = Color(0xFFEF5350); // Red 400

  static const Color infoLight    = Color(0xFF0277BD); // Light Blue 800
  static const Color infoDark     = Color(0xFF29B6F6); // Light Blue 400

  // ── Overlay / Scrim ──────────────────────────────────────────────────────────
  static const Color overlayLight = Color(0x1A5C6BC0); // primary 10 %
  static const Color overlayDark  = Color(0x1A7986CB); // primary 10 %

  static const Color scrimLight   = Color(0x805C6BC0);
  static const Color scrimDark    = Color(0x80000000);

  // ── Gradient helpers ─────────────────────────────────────────────────────────
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF5C6BC0), Color(0xFF26C6DA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF7986CB), Color(0xFF4DD0E1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ── ThemeExtension so colors are accessible via Theme.of(context) ─────────────

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color elevatedSurface;
  final Color appBar;
  final Color border;
  final Color outline;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color overlay;
  final Color scrim;
  final LinearGradient primaryGradient;

  const AppColorScheme({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.elevatedSurface,
    required this.appBar,
    required this.border,
    required this.outline,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.overlay,
    required this.scrim,
    required this.primaryGradient,
  });

  static const AppColorScheme light = AppColorScheme(
    primary: AppColors.primaryLight,
    primaryVariant: AppColors.primaryVariantLight,
    secondary: AppColors.secondaryLight,
    secondaryVariant: AppColors.secondaryVariantLight,
    background: AppColors.backgroundLight,
    surface: AppColors.surfaceLight,
    surfaceVariant: AppColors.surfaceVariantLight,
    elevatedSurface: AppColors.elevatedSurfaceLight,
    appBar: AppColors.appBarLight,
    border: AppColors.borderLight,
    outline: AppColors.outlineLight,
    divider: AppColors.dividerLight,
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    textHint: AppColors.textHintLight,
    success: AppColors.successLight,
    warning: AppColors.warningLight,
    error: AppColors.errorLight,
    info: AppColors.infoLight,
    overlay: AppColors.overlayLight,
    scrim: AppColors.scrimLight,
    primaryGradient: AppColors.primaryGradientLight,
  );

  static const AppColorScheme dark = AppColorScheme(
    primary: AppColors.primaryDark,
    primaryVariant: AppColors.primaryVariantDark,
    secondary: AppColors.secondaryDark,
    secondaryVariant: AppColors.secondaryVariantDark,
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    surfaceVariant: AppColors.surfaceVariantDark,
    elevatedSurface: AppColors.elevatedSurfaceDark,
    appBar: AppColors.appBarDark,
    border: AppColors.borderDark,
    outline: AppColors.outlineDark,
    divider: AppColors.dividerDark,
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    textHint: AppColors.textHintDark,
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    error: AppColors.errorDark,
    info: AppColors.infoDark,
    overlay: AppColors.overlayDark,
    scrim: AppColors.scrimDark,
    primaryGradient: AppColors.primaryGradientDark,
  );

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? secondary,
    Color? secondaryVariant,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? elevatedSurface,
    Color? appBar,
    Color? border,
    Color? outline,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? overlay,
    Color? scrim,
    LinearGradient? primaryGradient,
  }) {
    return AppColorScheme(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondary: secondary ?? this.secondary,
      secondaryVariant: secondaryVariant ?? this.secondaryVariant,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      appBar: appBar ?? this.appBar,
      border: border ?? this.border,
      outline: outline ?? this.outline,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      overlay: overlay ?? this.overlay,
      scrim: scrim ?? this.scrim,
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryVariant:
          Color.lerp(secondaryVariant, other.secondaryVariant, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      elevatedSurface:
          Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      appBar: Color.lerp(appBar, other.appBar, t)!,
      border: Color.lerp(border, other.border, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
    );
  }
}

// ── Quick access extension ────────────────────────────────────────────────────

extension AppColorSchemeContext on BuildContext {
  /// Quick access: `context.appColors.primary`
  AppColorScheme get appColors =>
      Theme.of(this).extension<AppColorScheme>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppColorScheme.dark
          : AppColorScheme.light);
}
