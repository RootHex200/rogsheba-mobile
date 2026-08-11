import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:rogsheba_mobile/core/config/app_config.dart';
import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';

/// Thin, envelope-aware wrapper around Dio.
///
/// - Decodes the raw UTF-8 body **explicitly** rather than trusting platform
///   defaults (all API payloads are Bangla).
/// - Turns transport failures and the API's `{success, error}` body into an
///   [ApiException] with the Bangla message intact, in one place.
class ApiClient {
  ApiClient(this._dio, this._config);

  final Dio _dio;
  final AppConfig _config;

  /// `/triage` is a slow-but-working request out of the box: the AI upstream
  /// takes 2–6s, so it is allowed up to 30s before giving up.
  Duration get triageTimeout => _config.triageTimeout;

  Future<Map<String, dynamic>> post(
    String path,
    Object? data, {
    Duration? timeout,
  }) async {
    final effectiveTimeout = timeout ?? _config.defaultTimeout;
    try {
      final response = await _dio.post<Uint8List>(
        path,
        data: data,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: effectiveTimeout,
          sendTimeout: effectiveTimeout,
        ),
      );
      return _decode(response.data, effectiveTimeout);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, dynamic> _decode(Uint8List? bytes, Duration timeout) {
    if (bytes == null) {
      throw const ApiException('empty_response', BnStrings.networkError);
    }
    final String decoded;
    try {
      decoded = utf8.decode(bytes, allowMalformed: false);
    } on FormatException {
      throw const ApiException('bad_encoding', BnStrings.genericError);
    }
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  ApiException _mapDioException(DioException e) {
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
}
