import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/theme/app_theme_tokens.dart';
import 'package:rogsheba_mobile/features/emergency/presentation/emergency_sheet.dart';

/// The web header's red emergency pill (`৯৯৯` → taps open the hotline sheet).
///
/// Lives in the emergency feature so every screen's AppBar reaches the same
/// chrome (and the same on-tap behaviour) from one source. Wrapped in an
/// `InkWell` to give the tap a pressed ripple without changing the visual —
/// the chip stays informational chrome from a screen away.
class HotlinePill extends StatelessWidget {
  const HotlinePill({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: Material(
          color: scheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xxxl),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.xxxl),
            onTap: () => showEmergencySheet(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              child: Text(
                BnStrings.hotline999,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onError,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
