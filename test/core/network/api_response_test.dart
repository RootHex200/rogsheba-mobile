import 'package:flutter_test/flutter_test.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';
import 'package:rogsheba_mobile/core/network/api_response.dart';

void main() {
  group('unwrapApiEnvelope', () {
    test('returns the data map on success', () {
      final data = unwrapApiEnvelope({
        'success': true,
        'data': {'level': 'YELLOW'},
      });
      expect(data, {'level': 'YELLOW'});
    });

    test('returns an empty map when success but data is absent', () {
      expect(unwrapApiEnvelope(const {'success': true}), isEmpty);
    });

    test('throws the API code and Bangla message on error', () {
      expect(
        () => unwrapApiEnvelope({
          'success': false,
          'error': {
            'code': 'validation_failed',
            'message': 'Invalid request body.',
          },
        }),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'validation_failed')
              .having((e) => e.message, 'message', 'Invalid request body.'),
        ),
      );
    });

    test('falls back to a generic error when the error shape is unknown', () {
      expect(
        () => unwrapApiEnvelope(const {'success': false}),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'unknown_error'),
        ),
      );
    });
  });
}
