import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/theme/app_colors.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_level.dart';

/// Triage level → colour mapping, resolved through the theme.
///
/// Kept as a `ThemeExtension` (not loose constants) so the level→colour map is
/// exercised through the same path in both light and dark, and so golden tests
/// inherit it. The mapping only exists here.
@immutable
class TriageColors extends ThemeExtension<TriageColors> {
  const TriageColors({
    required this.green,
    required this.greenForeground,
    required this.yellow,
    required this.yellowForeground,
    required this.red,
    required this.redForeground,
  });

  const TriageColors.light()
    : green = AppColors.triageGreen,
      greenForeground = AppColors.triageGreenForeground,
      yellow = AppColors.triageYellow,
      yellowForeground = AppColors.triageYellowForeground,
      red = AppColors.triageRed,
      redForeground = AppColors.triageRedForeground;

  const TriageColors.dark() : this.light();

  final Color green;
  final Color greenForeground;
  final Color yellow;
  final Color yellowForeground;
  final Color red;
  final Color redForeground;

  Color backgroundFor(TriageLevel level, {required bool isForeground}) {
    final normalized = switch (level) {
      TriageLevel.green => (green, greenForeground),
      TriageLevel.yellow => (yellow, yellowForeground),
      TriageLevel.red => (red, redForeground),
    };
    return isForeground ? normalized.$2 : normalized.$1;
  }

  @override
  TriageColors copyWith({
    Color? green,
    Color? greenForeground,
    Color? yellow,
    Color? yellowForeground,
    Color? red,
    Color? redForeground,
  }) {
    return TriageColors(
      green: green ?? this.green,
      greenForeground: greenForeground ?? this.greenForeground,
      yellow: yellow ?? this.yellow,
      yellowForeground: yellowForeground ?? this.yellowForeground,
      red: red ?? this.red,
      redForeground: redForeground ?? this.redForeground,
    );
  }

  @override
  TriageColors lerp(ThemeExtension<TriageColors>? other, double t) {
    if (other is! TriageColors) return this;
    return TriageColors(
      green: Color.lerp(green, other.green, t)!,
      greenForeground: Color.lerp(greenForeground, other.greenForeground, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      yellowForeground: Color.lerp(
        yellowForeground,
        other.yellowForeground,
        t,
      )!,
      red: Color.lerp(red, other.red, t)!,
      redForeground: Color.lerp(redForeground, other.redForeground, t)!,
    );
  }
}
