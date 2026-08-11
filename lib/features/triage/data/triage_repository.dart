import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/network/api_client.dart';
import 'package:rogsheba_mobile/core/network/api_response.dart';
import 'package:rogsheba_mobile/core/network/network_providers.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';

/// Speaks only to `POST /triage`. Feature code never sees the envelope.
class TriageRepository {
  const TriageRepository({required this.api});

  final ApiClient api;

  Future<TriageResult> submitSymptoms(String symptoms) async {
    final envelope = await api.post('/triage', {
      'symptoms': symptoms,
    }, timeout: api.triageTimeout);
    return TriageResult.fromJson(unwrapApiEnvelope(envelope));
  }
}

final triageRepositoryProvider = Provider<TriageRepository>(
  (ref) => TriageRepository(api: ref.watch(apiClientProvider)),
);
