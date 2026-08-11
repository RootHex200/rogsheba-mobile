import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';
import 'package:rogsheba_mobile/features/triage/presentation/triage_controller.dart';

/// Walking-skeleton home screen: type Bangla symptoms, tap পরামর্শ নিন, see the
/// live triage result rendered as plain text. Deliberately unpolished — the
/// design system, voice and card layout land in later issues.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(triageControllerProvider);
    final controller = ref.read(triageControllerProvider.notifier);

    final Widget submitChild;
    if (state.isSubmitting) {
      submitChild = const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text(BnStrings.submitting),
        ],
      );
    } else {
      submitChild = const Text(BnStrings.submit);
    }

    return Scaffold(
      appBar: AppBar(title: const Text(BnStrings.appTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: controller.onSymptomsChanged,
                onSubmitted: (_) => controller.submit(),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: BnStrings.symptomLabel,
                  hintText: BnStrings.symptomHint,
                  helperText: BnStrings.symptomsHelp,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: state.canSubmit ? controller.submit : null,
                child: submitChild,
              ),
              const SizedBox(height: 16),
              if (state.errorMessage != null)
                Text(
                  state.errorMessage!,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              if (state.result != null) TriageResultView(result: state.result!),
            ],
          ),
        ),
      ),
    );
  }
}

class TriageResultView extends StatelessWidget {
  const TriageResultView({required this.result, super.key});

  final TriageResult result;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.titleBn,
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(result.summaryBn, style: textTheme.bodyLarge),
          const SizedBox(height: 12),
          Text(
            '${BnStrings.adviceTitle}:',
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          for (final (index, step) in result.adviceBn.indexed)
            Text('${index + 1}. $step', style: textTheme.bodyMedium),
          if (result.warningSignsBn.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '${BnStrings.warningSignsTitle}:',
              style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            for (final sign in result.warningSignsBn)
              Text('• $sign', style: textTheme.bodyMedium),
          ],
          if (result.followupQuestionBn != null) ...[
            const SizedBox(height: 12),
            Text(
              '${BnStrings.followupTitle}: ${result.followupQuestionBn}',
              style: textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 12),
          Text(result.disclaimerBn, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
