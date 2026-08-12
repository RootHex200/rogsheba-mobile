import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/network/api_client.dart';
import 'package:rogsheba_mobile/core/network/api_response.dart';
import 'package:rogsheba_mobile/core/network/network_providers.dart';
import 'package:rogsheba_mobile/features/emergency/domain/emergency_contact.dart';

/// Speaks only to `GET /emergency`. Same envelope seam as `ClinicsRepository`,
/// so adding a new endpoint costs three lines of code but no new error path.
///
/// Caching for offline is explicitly out of scope here — Issue #11 owns the
/// `shared_preferences` layer. The repository just talks to the API.
class EmergencyRepository {
  const EmergencyRepository({required this.api});

  final ApiClient api;

  Future<EmergencyContactsResponse> fetchContacts() async {
    final envelope = await api.get('/emergency');
    return EmergencyContactsResponse.fromJson(
      unwrapApiEnvelope(envelope),
    );
  }
}

final emergencyRepositoryProvider = Provider<EmergencyRepository>(
  (ref) => EmergencyRepository(api: ref.watch(apiClientProvider)),
);
