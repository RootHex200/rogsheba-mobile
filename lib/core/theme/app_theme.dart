import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/theme/app_colors.dart';
import 'package:rogsheba_mobile/core/theme/app_theme_tokens.dart';
import 'package:rogsheba_mobile/core/theme/triage_colors.dart';

/// Builds the app theme in both brightnesses from the ported tokens.
///
/// Fonts are bundled assets — system font fallback is explicitly not relied
/// upon (text must render identically on every device).
ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.lightPrimary,
    brightness: brightness,
    primary: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
    onPrimary: isDark
        ? AppColors.darkPrimaryForeground
        : AppColors.lightPrimaryForeground,
    secondary: isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
    onSecondary: isDark
        ? AppColors.darkSecondaryForeground
        : AppColors.lightSecondaryForeground,
    surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    onSurface: isDark ? AppColors.darkForeground : AppColors.lightForeground,
    surfaceContainer: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    surfaceContainerHighest: isDark
        ? AppColors.darkMuted
        : AppColors.lightMuted,
    onSurfaceVariant: isDark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground,
    outline: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    error: AppColors.lightDestructive,
    onError: AppColors.lightDestructiveForeground,
  );

  final background = isDark
      ? AppColors.darkBackground
      : AppColors.lightBackground;
  final onBackground = isDark
      ? AppColors.darkForeground
      : AppColors.lightForeground;

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    fontFamily: AppFonts.bangla,
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: onBackground,
      displayColor: onBackground,
      fontFamily: AppFonts.bangla,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: onBackground,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkInput : AppColors.lightInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkPrimary : AppColors.lightRing,
          width: 2,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
    ),
    extensions: [
      if (isDark) const TriageColors.dark() else const TriageColors.light(),
    ],
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: scheme.primary),
    ),
  );
}

/// Resolves the [TriageColors] extension from any build context.
TriageColors triageColorsOf(BuildContext context) =>
    Theme.of(context).extension<TriageColors>()!;
