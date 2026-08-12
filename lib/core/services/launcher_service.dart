import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Pure URL construction for the clinics deep links. Kept deliberately free of
/// any IO so the exact strings are unit-testable without launching anything.
abstract final class MapUrls {
  /// Google Maps turn-by-turn directions from the user's position.
  ///
  /// Falls back to the Maps `search` variant when the origin (the user's own
  /// coordinates) is unknown — same degradation as on the web.
  static Uri directions({
    required double destinationLat,
    required double destinationLon,
    double? originLat,
    double? originLon,
  }) {
    if (originLat != null && originLon != null) {
      return Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=$originLat,$originLon'
        '&destination=$destinationLat,$destinationLon',
      );
    }
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=$destinationLat,$destinationLon',
    );
  }

  /// Opens the facility's location at level 17 on OpenStreetMap.
  static Uri osmLocation({required double lat, required double lon}) {
    return Uri.parse(
      'https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=17/$lat/$lon',
    );
  }
}

/// Opens external apps (maps deep links here, `tel:` for emergency numbers).
/// A function type keeps the seam injectable for tests without a launched
/// platform channel: [launcherServiceProvider] is overridden with a closure
/// that records the URIs.
typedef OpenExternalUri = Future<bool> Function(Uri uri);

Future<bool> _launchExternal(Uri uri) {
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

final launcherServiceProvider = Provider<OpenExternalUri>(
  (_) => _launchExternal,
);
