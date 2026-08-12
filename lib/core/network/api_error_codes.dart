import 'package:rogsheba_mobile/core/network/api_exception.dart';

/// The error `code` values the public API documents (`docs/MOBILE_API.md`).
///
/// Feature code branches on these via an [ApiException]'s `code`. Unknown
/// codes are never a decode failure — they flow through as-is.
abstract final class ApiErrorCode {
  static const invalidJson = 'invalid_json';
  static const validationFailed = 'validation_failed';
  static const rateLimited = 'rate_limited';
  static const creditsExhausted = 'credits_exhausted';
  static const aiUpstreamError = 'ai_upstream_error';
  static const clinicLookupFailed = 'clinic_lookup_failed';
  static const internalError = 'internal_error';

  /// Every code the API documents. Absence from this list just means the
  /// server sent a newer code, which still maps to a typed exception.
  static const List<String> documented = [
    invalidJson,
    validationFailed,
    rateLimited,
    creditsExhausted,
    aiUpstreamError,
    clinicLookupFailed,
    internalError,
  ];
}
