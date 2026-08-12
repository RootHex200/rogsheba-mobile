import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/api_error_codes.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';
import 'package:rogsheba_mobile/core/network/dio_error_mapper.dart';

import '../../helpers/fixtures.dart';

RequestOptions _options() => RequestOptions(
      path: '/triage',
      baseUrl: 'https://api.test',
    );

DioException _timeout(DioExceptionType type) => DioException(
      requestOptions: _options(),
      type: type,
    );

DioException _envelope(
  Map<String, dynamic> body, {
  required int status,
}) =>
    DioException(
      requestOptions: _options(),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: _options(),
        statusCode: status,
        data: body is Uint8List ? body : _bytes(body),
      ),
    );

Uint8List _bytes(Map<String, dynamic> json) =>
    Uint8List.fromList(utf8.encode(jsonEncode(json)));

void main() {
  group('mapDioError', () {
    test('a receive timeout becomes the Bangla timeout error', () {
      final e = mapDioError(_timeout(DioExceptionType.receiveTimeout));

      expect(e, isA<ApiException>());
      expect(e.code, 'request_timeout');
      expect(e.message, BnStrings.timeoutError);
    });

    test('send and connect timeouts map the same way', () {
      for (final type in [
        DioExceptionType.sendTimeout,
        DioExceptionType.connectionTimeout,
      ]) {
        final e = mapDioError(_timeout(type));
        expect(e.code, 'request_timeout');
        expect(e.message, BnStrings.timeoutError);
      }
    });

    test('an API error envelope keeps its code and Bangla message verbatim',
        () {
      final e = mapDioError(_envelope(banglaErrorEnvelope, status: 422));

      expect(e, isA<ApiException>());
      expect(e.code, 'validation_failed');
      expect(e.message, 'অন্তত ৩টি অক্ষর লিখুন।');
      expect(e.statusCode, 422);
    });

    test('every documented API error code maps to a typed exception', () {
      final envelopes = <String, Map<String, dynamic>>{
        'invalid_json': {
          'success': false,
          'error': {'code': 'invalid_json', 'message': 'অবৈধ অনুরোধ।'},
        },
        'validation_failed': banglaErrorEnvelope,
        'rate_limited': rateLimitedEnvelope,
        'credits_exhausted': {
          'success': false,
          'error': {
            'code': 'credits_exhausted',
            'message': 'সার্ভিস সাময়িকভাবে বন্ধ',
          },
        },
        'ai_upstream_error': {
          'success': false,
          'error': {
            'code': 'ai_upstream_error',
            'message': 'এআই সার্ভিসে সমস্যা হয়েছে।',
          },
        },
        'clinic_lookup_failed': {
          'success': false,
          'error': {
            'code': 'clinic_lookup_failed',
            'message': 'ক্লিনিক খুঁজে পাওয়া যায়নি।',
          },
        },
        'internal_error': internalErrorEnvelope,
      };

      for (final code in ApiErrorCode.documented) {
        final envelope = envelopes[code];
        expect(envelope, isNotNull, reason: 'missing fixture for $code');
        final e = mapDioError(_envelope(envelope!, status: 400));

        expect(e, isA<ApiException>());
        expect(e.code, code);
        expect(e.message, isNotEmpty);
      }
    });

    test('a socket failure becomes the network error', () {
      final e = mapDioError(DioException(requestOptions: _options()));

      expect(e.code, 'network_error');
      expect(e.message, BnStrings.networkError);
    });
  });
}
