import 'package:flutter/material.dart';

/// The web's radius scale: base `16.0` (`--radius: 1rem`) with
/// `sm/md/lg/xl/2xl/3xl` = `12 / 14 / 16 / 20 / 24 / 28`.
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 28;
}

/// Bundled font family names, matching the `pubspec.yaml` font assets.
abstract final class AppFonts {
  /// All Bangla text (web `.font-bangla`).
  static const String bangla = 'Noto Sans Bengali';

  /// Latin / display (web `--font-display`).
  static const String display = 'Plus Jakarta Sans';
}

/// Two-layer soft shadow (web `shadowSoft`).
const List<BoxShadow> kShadowSoft = [
  BoxShadow(color: Color(0x0A002022), blurRadius: 2, offset: Offset(0, 1)),
  BoxShadow(color: Color(0x0F002022), blurRadius: 24, offset: Offset(0, 8)),
];
