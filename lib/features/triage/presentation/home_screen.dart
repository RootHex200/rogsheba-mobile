import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/features/triage/presentation/triage_controller.dart';
import 'package:rogsheba_mobile/features/triage/presentation/triage_result_card.dart';
import 'package:rogsheba_mobile/shared/widgets/app_button.dart';
import 'package:rogsheba_mobile/shared/widgets/app_card.dart';
import 'package:rogsheba_mobile/shared/widgets/app_chip.dart';

/// The home / triage screen, porting the web layout: hero, symptom entry card,
/// example chips, feature strip and the [TriageResultCard]. All colours and
/// geometry resolve through the theme — no hardcoded tokens in feature code.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(triageControllerProvider);
    final controller = ref.read(triageControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          BnStrings.appTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 768),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Hero(),
                  const SizedBox(height: 24),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          onChanged: controller.onSymptomsChanged,
                          onSubmitted: (_) => controller.submit(),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: BnStrings.symptomPlaceholder,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: state.isSubmitting
                              ? BnStrings.submitting
                              : BnStrings.submit,
                          isLoading: state.isSubmitting,
                          onPressed: state.canSubmit ? controller.submit : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          BnStrings.inlineDisclaimer,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: scheme.error),
                          ),
                        ],
                        if (state.result == null && !state.isSubmitting)
                          const _ExampleChips(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _FeatureStrip(),
                  if (state.result != null) ...[
                    const SizedBox(height: 24),
                    TriageResultCard(result: state.result!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final title = TextSpan(
      children: [
        const TextSpan(text: 'আপনার লক্ষণ বলুন — '),
        TextSpan(
          text: 'তাৎক্ষণিক স্বাস্থ্য পরামর্শ',
          style: TextStyle(color: scheme.primary),
        ),
        const TextSpan(text: ' পান'),
      ],
    );
    return Column(
      children: [
        Text.rich(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          BnStrings.heroSubtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ExampleChips extends ConsumerWidget {
  const _ExampleChips();

  static const _examples = [
    BnStrings.exampleFeverThroat,
    BnStrings.exampleChestPain,
    BnStrings.exampleStomach,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(triageControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BnStrings.exampleHeader,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final example in _examples)
                AppChip(
                  label: example,
                  onTap: () => controller.onSymptomsChanged(example),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureStrip extends StatelessWidget {
  const _FeatureStrip();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _FeatureItem(
          icon: Icons.health_and_safety_outlined,
          title: BnStrings.featureTriageTitle,
          body: BnStrings.featureTriageBody,
        ),
        _FeatureItem(
          icon: Icons.local_hospital_outlined,
          title: BnStrings.featureClinicsTitle,
          body: BnStrings.featureClinicsBody,
        ),
        _FeatureItem(
          icon: Icons.lock_outline,
          title: BnStrings.featurePrivateTitle,
          body: BnStrings.featurePrivateBody,
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: scheme.primary, size: 28),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  body,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
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
