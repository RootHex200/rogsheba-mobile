/// Backend connection configuration.
///
/// The API base URL lives here, and per-endpoint timeouts are declared once so
/// repositories never sprinkle magic `Duration` values around.
class AppConfig {
  const AppConfig({
    required this.baseUrl,
    this.triageTimeout = const Duration(seconds: 30),
    this.defaultTimeout = const Duration(seconds: 10),
  });

  static const AppConfig production = AppConfig(
    baseUrl: 'https://project-kitchen-ready.lovable.app/api/public/v1',
  );

  static const AppConfig staging = AppConfig(
    baseUrl:
        'https://id-preview--ec4ef559-37b7-4522-a535-4c0f3aa92061.lovable.app/api/public/v1',
  );

  final String baseUrl;

  /// `/triage` is allowed up to 30s because the AI upstream typically takes
  /// 2–6s and must never be cut off by a premature default timeout.
  final Duration triageTimeout;

  final Duration defaultTimeout;
}
