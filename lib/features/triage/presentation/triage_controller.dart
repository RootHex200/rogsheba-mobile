import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';
import 'package:rogsheba_mobile/features/triage/data/triage_repository.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';

/// State backing the home screen's symptom entry + result.
class TriageFormState {
  const TriageFormState({
    this.symptoms = '',
    this.isSubmitting = false,
    this.result,
    this.errorMessage,
  });

  final String symptoms;
  final bool isSubmitting;
  final TriageResult? result;

  /// Already-Bangla message shown verbatim, or `null` when all is well.
  final String? errorMessage;

  /// Submit is disabled only while the field is empty or a request is in
  /// flight (prevents double submission).
  bool get canSubmit => symptoms.trim().isNotEmpty && !isSubmitting;

  TriageFormState copyWith({
    String? symptoms,
    bool? isSubmitting,
    TriageResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return TriageFormState(
      symptoms: symptoms ?? this.symptoms,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      result: clearResult ? null : result ?? this.result,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class TriageController extends Notifier<TriageFormState> {
  @override
  TriageFormState build() => const TriageFormState();

  void onSymptomsChanged(String value) {
    state = state.copyWith(symptoms: value, clearError: true);
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final result = await ref
          .read(triageRepositoryProvider)
          .submitSymptoms(state.symptoms.trim());
      state = state.copyWith(isSubmitting: false, result: result);
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: BnStrings.genericError,
      );
    }
  }
}

final triageControllerProvider =
    NotifierProvider<TriageController, TriageFormState>(TriageController.new);
