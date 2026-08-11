import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';

/// Placeholder until the clinics slice (#8) lands: the real screen will
/// auto-locate, list nearest-first and deep-link directions. For now the route
/// exists so the triage card's "নিকটস্থ ক্লিনিক খুঁজুন" CTA has a destination.
class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(BnStrings.clinicsAppBarTitle)),
    );
  }
}
