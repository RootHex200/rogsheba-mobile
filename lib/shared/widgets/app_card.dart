import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/theme/app_theme_tokens.dart';

/// Surface card with the web's soft two-layer shadow and base radius.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
        boxShadow: kShadowSoft,
      ),
      child: child,
    );
  }
}
