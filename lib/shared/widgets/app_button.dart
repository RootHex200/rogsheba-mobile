import 'package:flutter/material.dart';

import 'package:rogsheba_mobile/core/theme/app_theme_tokens.dart';

/// Full-width pill button (web `AppButton`), the app's primary action control.
/// Disabled while [isLoading] or when [onPressed] is `null`, so a request in
/// flight can never be submitted twice.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = !isLoading && onPressed != null;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xxxl),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          disabledBackgroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(label),
                ],
              )
            : Text(label),
      ),
    );
  }
}
