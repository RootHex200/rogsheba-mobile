import 'package:flutter/material.dart';

/// Design tokens ported from the web, pre-converted from oklch to hex per
/// `docs/MOBILE_PLAN.md` §3. No runtime colour-space conversion.
///
/// Light and dark variants are consts so themes/builders can reference them
/// without allocation. Widgets must resolve colours through `Theme.of(context)`
/// / the `TriageColors` `ThemeExtension`, never by importing these directly.
abstract final class AppColors {
  // ---- Light ----
  static const Color lightBackground = Color(0xFFFCFAF1);
  static const Color lightForeground = Color(0xFF002022);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF006B5A);
  static const Color lightPrimaryForeground = Color(0xFFFCFAF3);
  static const Color lightSecondary = Color(0xFFD9F2E8);
  static const Color lightSecondaryForeground = Color(0xFF00322F);
  static const Color lightMuted = Color(0xFFF1EFE4);
  static const Color lightMutedForeground = Color(0xFF4F696A);
  static const Color lightAccent = Color(0xFFF87B5C);
  static const Color lightAccentForeground = Color(0xFFFEFCF4);
  static const Color lightBorder = Color(0xFFD2E3DC);
  static const Color lightInput = Color(0xFFD8E9E2);
  static const Color lightRing = Color(0xFF006B5A);

  static const Color lightDestructive = Color(0xFFD40C1A);
  static const Color lightDestructiveForeground = Color(0xFFFEFCF4);

  // ---- Dark overrides (triage colours unchanged) ----
  static const Color darkBackground = Color(0xFF001517);
  static const Color darkForeground = Color(0xFFF7F5EE);
  static const Color darkSurface = Color(0xFF002022);
  static const Color darkPrimary = Color(0xFF2FBDA7);
  static const Color darkPrimaryForeground = Color(0xFF001517);
  static const Color darkSecondary = Color(0xFF00312E);
  static const Color darkSecondaryForeground = Color(0xFFF7F5EE);
  static const Color darkMuted = Color(0xFF052A2C);
  static const Color darkMutedForeground = Color(0xFF8BA59F);
  static const Color darkAccent = Color(0xFFFF8465);
  static const Color darkAccentForeground = Color(0xFFFEFCF4);

  /// `border` and `input` are white at 12% / 14% in dark mode.
  static const Color darkBorder = Color(0x1FFFF5EE);
  static const Color darkInput = Color(0x24FFFFFF);

  // ---- Triage levels (identical in both brightnesses) ----
  static const Color triageGreen = Color(0xFF2EA957);
  static const Color triageGreenForeground = Color(0xFFFEFCF4);
  static const Color triageYellow = Color(0xFFF3BA25);
  static const Color triageYellowForeground = Color(0xFF301D00);
  static const Color triageRed = Color(0xFFE31029);
  static const Color triageRedForeground = Color(0xFFFEFCF4);
}
