import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/network/api_client.dart';
import 'package:rogsheba_mobile/core/network/api_response.dart';
import 'package:rogsheba_mobile/core/network/network_providers.dart';
import 'package:rogsheba_mobile/features/clinics/domain/clinics_response.dart';

/// Speaks only to `GET /clinics`. Feature code never sees the envelope.
///
/// The web's client-side OpenStreetMap query is deliberately *not* ported —
/// the endpoint already runs it server-side and shields the client from
/// upstream slowness. Omitting `lat`/`lon` asks the server for its curated
/// Dhaka fallback list (the slice #9 path).
class ClinicsRepository {
  const ClinicsRepository({required this.api});

  final ApiClient api;

  Future<ClinicsResponse> fetchNearby({double? lat, double? lon}) async {
    final envelope = await api.get('/clinics', queryParameters: {
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
    });
    return ClinicsResponse.fromJson(unwrapApiEnvelope(envelope));
  }
}

final clinicsRepositoryProvider = Provider<ClinicsRepository>(
  (ref) => ClinicsRepository(api: ref.watch(apiClientProvider)),
);
