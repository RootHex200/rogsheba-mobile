/// One nearby facility returned by `GET /clinics`.
///
/// Parsed leniently per the API's versioning note: unknown fields are ignored
/// and optional fields (`type`, `address`) stay `null`, never a decode failure.
class Clinic {
  const Clinic({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.distanceKm,
    this.type,
    this.address,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      type: json['type'] as String?,
      address: json['address'] as String?,
    );
  }

  final String id;
  final String name;
  final double lat;
  final double lon;
  final double distanceKm;

  /// `hospital | clinic | doctors | Government | Private`, as returned.
  final String? type;
  final String? address;
}
