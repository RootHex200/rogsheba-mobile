import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';

/// Central transport-to-exception mapping.
///
/// Everything that can go wrong at the socket or envelope layer becomes one
/// typed [ApiException] here, so feature code never re-implements it. Timeouts
/// (which Dio surfaces as a [DioException] with no response body) become a
/// Bangla timeout error; anything with an API error envelope keeps the API's
/// `code` and its already-Bangla `message` verbatim, plus the HTTP status.
///
/// Lives outside `ApiClient` purely so the mapping is unit-testable without
/// standing up a Dio.
ApiException mapDioError(DioException e) {
  if (_isTimeout(e)) {
    return const ApiException('request_timeout', BnStrings.timeoutError);
  }

  final responseBody = e.response?.data;
  if (responseBody is Uint8List) {
    try {
      final envelope =
          jsonDecode(utf8.decode(responseBody)) as Map<String, dynamic>;
      if (envelope['success'] == false) {
        final error = envelope['error'];
        if (error is Map<String, dynamic>) {
          return ApiException(
            (error['code'] as String?) ?? 'unknown_error',
            (error['message'] as String?) ?? BnStrings.genericError,
            statusCode: e.response?.statusCode,
          );
        }
      }
    } on FormatException {
      // Fall through to the generic mapping below.
    }
  }
  return ApiException(
    'network_error',
    BnStrings.networkError,
    statusCode: e.response?.statusCode,
  );
}

bool _isTimeout(DioException e) {
  return e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionTimeout;
}
