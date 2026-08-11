import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Narrow device-capability seam for launching external apps.
///
/// Deliberately small so a hand-written fake can assert *which* URIs were
/// launched without ever touching a platform channel. URL construction lives
/// here too so it is unit-testable without launching anything.
abstract interface class LauncherService {
  /// Opens [uri] in the appropriate external app (e.g. `tel:999`,
  /// `https://google.com/maps/dir/...`).
  Future<bool> open(String uri);

  /// Builds a `tel:` URI for the given number, e.g. `999` → `tel:999`.
  static String telUri(String number) => 'tel:$number';
}

/// Real implementation backed by `url_launcher`.
class UrlLauncherService implements LauncherService {
  const UrlLauncherService();

  @override
  Future<bool> open(String uri) => launchUrl(Uri.parse(uri));
}

final launcherServiceProvider = Provider<LauncherService>(
  (ref) => const UrlLauncherService(),
);
