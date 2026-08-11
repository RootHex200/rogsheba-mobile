import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/services/launcher_service.dart';
import 'package:rogsheba_mobile/core/theme/app_theme.dart';
import 'package:rogsheba_mobile/core/theme/app_theme_tokens.dart';
import 'package:rogsheba_mobile/features/clinics/presentation/clinics_screen.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_level.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';

/// The full triage result card, faithful to the web component:
/// coloured level band, headline + summary, RED emergency block, numbered
/// advice, distinct warning-signs block, follow-up block, clinics CTA and the
/// always-visible disclaimer.
///
/// Safety contract: the level was already normalised to
/// [TriageLevel.yellow] on decode for any unrecognised/absent value, so an
/// unparseable model response is never rendered as GREEN.
class TriageResultCard extends ConsumerWidget {
  const TriageResultCard({required this.result, super.key});

  final TriageResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final triage = triageColorsOf(context);
    final bandColor = triage.backgroundFor(result.level, isForeground: false);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xxxl),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: bandColor.withValues(alpha: 0.3),
            spreadRadius: 4,
          ),
          ...kShadowSoft,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LevelBand(level: result.level),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.titleBn,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.summaryBn,
                  style: textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (result.level == TriageLevel.red) ...[
                  const SizedBox(height: 16),
                  const _RedEmergencyBlock(),
                ],
                if (result.adviceBn.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _AdviceSection(steps: result.adviceBn),
                ],
                if (result.warningSignsBn.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _WarningSignsBlock(signs: result.warningSignsBn),
                ],
                if (result.followupQuestionBn != null) ...[
                  const SizedBox(height: 16),
                  _FollowUpBlock(question: result.followupQuestionBn!),
                ],
                const SizedBox(height: 16),
                const _ClinicsCta(),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: scheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  child: Text(
                    '${BnStrings.disclaimerPrefix}${result.disclaimerBn}',
                    style: textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelBand extends StatelessWidget {
  const _LevelBand({required this.level});

  final TriageLevel level;

  @override
  Widget build(BuildContext context) {
    final triage = triageColorsOf(context);
    final color = triage.backgroundFor(level, isForeground: false);
    final foreground = triage.backgroundFor(level, isForeground: true);
    final (label, sub, icon) = switch (level) {
      TriageLevel.green => (
        BnStrings.levelGreen,
        BnStrings.levelGreenSub,
        Icons.check_circle_rounded,
      ),
      TriageLevel.yellow => (
        BnStrings.levelYellow,
        BnStrings.levelYellowSub,
        Icons.warning_amber_rounded,
      ),
      TriageLevel.red => (
        BnStrings.levelRed,
        BnStrings.levelRedSub,
        Icons.emergency_rounded,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: color,
      child: Row(
        children: [
          Icon(icon, color: foreground, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RedEmergencyBlock extends ConsumerWidget {
  const _RedEmergencyBlock();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final launcher = ref.read(launcherServiceProvider);
    void call(String number) => launcher.open(LauncherService.telUri(number));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.error, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            BnStrings.redEmergencyTitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: scheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CallButton(
                  label: BnStrings.call999,
                  filled: true,
                  onPressed: () => call('999'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CallButton(
                  label: BnStrings.call16263,
                  filled: false,
                  onPressed: () => call('16263'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = filled ? scheme.error : Colors.transparent;
    final foreground = filled ? scheme.onError : scheme.error;
    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: filled
            ? BorderSide.none
            : BorderSide(color: scheme.error, width: 2),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: foreground, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdviceSection extends StatelessWidget {
  const _AdviceSection({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(BnStrings.adviceTitle),
        for (final (index, step) in steps.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                  child: Text(
                    '${index + 1}',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(step, style: textTheme.bodyLarge),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WarningSignsBlock extends StatelessWidget {
  const _WarningSignsBlock({required this.signs});

  final List<String> signs;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BnStrings.warningSignsTitle.toUpperCase(),
            style: textTheme.labelMedium?.copyWith(
              color: scheme.tertiary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          for (final sign in signs)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.tertiary,
                    ),
                  ),
                  Expanded(
                    child: Text(sign, style: textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FollowUpBlock extends StatelessWidget {
  const _FollowUpBlock({required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.4)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: BnStrings.followupPrefix,
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: question),
          ],
        ),
      ),
    );
  }
}

class _ClinicsCta extends ConsumerWidget {
  const _ClinicsCta();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: scheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxxl),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ClinicsScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppRadius.xxxl),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: scheme.onPrimary, size: 18),
                const SizedBox(width: 8),
                Text(
                  BnStrings.nearbyClinicsCta,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
