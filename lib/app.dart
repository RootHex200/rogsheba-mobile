import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/features/triage/presentation/home_screen.dart';

/// Application root. Bangla-only in v1; the design system is minimal until the
/// dedicated design-system issue lands.
class RogShebaApp extends StatelessWidget {
  const RogShebaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BnStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF006B5A),
      ),
      home: const HomeScreen(),
    );
  }
}
