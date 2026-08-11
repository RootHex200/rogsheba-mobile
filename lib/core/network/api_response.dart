import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';

/// Central envelope handling for `{success, data}` / `{success, error}`.
///
/// One layer unwraps every response; feature code never touches the envelope.
/// The error branch is thrown as an [ApiException] carrying the API's `code`
/// and its already-Bangla `message` unchanged.
Map<String, dynamic> unwrapApiEnvelope(Map<String, dynamic> envelope) {
  if (envelope['success'] == true) {
    final data = envelope['data'];
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  final error = envelope['error'];
  if (error is Map<String, dynamic>) {
    throw ApiException(
      (error['code'] as String?) ?? 'unknown_error',
      (error['message'] as String?) ?? BnStrings.genericError,
    );
  }

  throw const ApiException('unknown_error', BnStrings.genericError);
}
