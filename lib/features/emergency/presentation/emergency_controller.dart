import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';
import 'package:rogsheba_mobile/features/emergency/data/emergency_repository.dart';
import 'package:rogsheba_mobile/features/emergency/domain/emergency_contact.dart';

/// Drives the emergency sheet. Fetches the contact list on first build;
/// exposes the standard `AsyncValue` so the sheet can render loading/error/
/// data branches without bespoke state.
class EmergencyController
    extends AsyncNotifier<List<EmergencyContact>> {
  @override
  Future<List<EmergencyContact>> build() async {
    final repo = ref.read(emergencyRepositoryProvider);
    final response = await repo.fetchContacts();
    return response.contacts;
  }

  /// Retry path used by the sheet's error branch.
  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(emergencyRepositoryProvider);
      final response = await repo.fetchContacts();
      return response.contacts;
    });
  }
}

/// Maps the `AsyncValue` error into a Bangla line for the sheet. The API
/// error message is preserved when present so the user sees something
/// more specific than the generic copy, just like the rest of the app.
String emergencyErrorMessage(Object error) {
  if (error is ApiException) return error.message;
  return BnStrings.emergencyLoadFailed;
}

final emergencyControllerProvider = AsyncNotifierProvider<
  EmergencyController, List<EmergencyContact>>(
  EmergencyController.new,
  // Retry is the user's choice: the sheet has its own "আবার চেষ্টা করুন"
  // pill. Disabling the framework default (10 attempts with exponential
  // backoff, up to 6.4s) avoids silent re-fetches while the Bangla error
  // copy is rendered.
  retry: (_, _) => null,
);
