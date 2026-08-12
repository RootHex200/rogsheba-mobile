import 'package:rogsheba_mobile/features/clinics/domain/clinic.dart';

/// The `GET /clinics` payload: source, the origin the distances were measured
/// from, and the nearest-first facility list.
class ClinicsResponse {
  /// `"openstreetmap"` when located, `"fallback"` for the curated Dhaka list
  /// the server returns when no coordinates were sent (slice #9's path).
  const ClinicsResponse({
    required this.source,
    required this.clinics,
    this.originLat,
    this.originLon,
  });

  factory ClinicsResponse.fromJson(Map<String, dynamic> json) {
    final origin = json['origin'];
    final originLat = origin is Map<String, dynamic>
        ? (origin['lat'] as num?)?.toDouble()
        : null;
    final originLon = origin is Map<String, dynamic>
        ? (origin['lon'] as num?)?.toDouble()
        : null;
    final raw = json['clinics'];
    return ClinicsResponse(
      source: json['source'] as String? ?? 'openstreetmap',
      originLat: originLat,
      originLon: originLon,
      clinics: raw is List
          ? raw
                .whereType<Map<String, dynamic>>()
                .map(Clinic.fromJson)
                .toList(growable: false)
          : const [],
    );
  }

  final String source;
  final double? originLat;
  final double? originLon;
  final List<Clinic> clinics;
}
