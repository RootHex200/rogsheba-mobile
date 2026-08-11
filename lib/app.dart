import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/theme/app_theme.dart';
import 'package:rogsheba_mobile/features/triage/presentation/home_screen.dart';

/// Application root. Bangla-only in v1. Light and dark themes follow the
/// system setting; both bundled fonts render identically on every device.
class RogShebaApp extends StatelessWidget {
  const RogShebaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BnStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
