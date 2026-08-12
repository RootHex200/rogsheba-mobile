import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// The explicit outcome of a location request.
///
/// The web collapses these into an error string; mobile keeps them distinct
/// because the recovery differs: #8 handles [LocationGranted], while #9 owns
/// the denied / disabled / failed fallback paths.
sealed class LocationResult {
  const LocationResult();
}

/// Location granted with coordinates.
class LocationGranted extends LocationResult {
  const LocationGranted({required this.lat, required this.lon});

  final double lat;
  final double lon;
}

/// Permission denied (or denied permanently) by the user.
class LocationDenied extends LocationResult {
  const LocationDenied();
}

/// Location services are switched off at the device level.
class LocationDisabled extends LocationResult {
  const LocationDisabled();
}

/// Anything else — timeout, transient sensor failure, plugin error.
class LocationFailed extends LocationResult {
  const LocationFailed();
}

/// Locates the user, returning an explicit outcome union — never a bare
/// nullable. Tests override [locationServiceProvider] with a fake closure.
typedef LocateUser = Future<LocationResult> Function();

/// Real implementation backed by `geolocator`.
///
/// Wraps the three-step web flow in the right order: check the service is on
/// (no point asking for permission on a device that cannot fix a position),
/// then request/check permission, then read the position with a timeout.
Future<LocationResult> _geolocatorLocate() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    return const LocationDisabled();
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return const LocationDenied();
  }

  try {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    return LocationGranted(lat: position.latitude, lon: position.longitude);
  } on TimeoutException {
    return const LocationFailed();
  } catch (_) {
    return const LocationFailed();
  }
}

/// Composition root. Tests override this with a hand-written fake.
final locationServiceProvider = Provider<LocateUser>((_) => _geolocatorLocate);
