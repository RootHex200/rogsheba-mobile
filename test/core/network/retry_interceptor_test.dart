import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rogsheba_mobile/core/network/retry_interceptor.dart';

import '../../helpers/fake_dio_adapter.dart';
import '../../helpers/fixtures.dart';

/// Builds a real Dio with the [RetryInterceptor] attached. The supplied
/// [wait] both records the requested delay and returns, so the 5s/15s/30s
/// schedule can be asserted without real waiting.
(Dio, FakeDioAdapter, List<Duration>) buildRetryDio({
  required Future<ResponseBody> Function(RequestOptions) handler,
  required Future<void> Function(Duration) wait,
}) {
  final waits = <Duration>[];
  final adapter = FakeDioAdapter(handler);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = adapter;
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      wait: (d) {
        waits.add(d);
        return wait(d);
      },
    ),
  );
  return (dio, adapter, waits);
}

Future<void> immediateWait(Duration _) => Future<void>.value();

void main() {
  group('retry policy', () {
    test('a 429 is retried three times with 5s/15s/30s gaps then succeeds',
        () {
      fakeAsync((async) {
        var calls = 0;
        final (dio, adapter, waits) = buildRetryDio(
          handler: (options) async {
            calls++;
            if (calls < 4) {
              return FakeDioAdapter.jsonBytes(rateLimitedEnvelope, status: 429);
            }
            return FakeDioAdapter.jsonBytes(triageEnvelope);
          },
          wait: Future<void>.delayed,
        );

        Object? result;
        Object? error;
        dio.post<dynamic>('/triage', data: const {'symptoms': 'বুকে ব্যথা'}).then(
          (v) => result = v.data,
          onError: (Object e) => error = e,
        );

        async
          ..flushMicrotasks()
          ..elapse(const Duration(seconds: 5))
          ..elapse(const Duration(seconds: 15))
          ..elapse(const Duration(seconds: 30))
          ..flushMicrotasks();

        expect(error, isNull);
        expect(result, isNotNull);
        expect(adapter.requests, hasLength(4));
        expect(waits, const [
          Duration(seconds: 5),
          Duration(seconds: 15),
          Duration(seconds: 30),
        ]);
      });
    });

    test('a 5xx is retried on the same schedule', () {
      fakeAsync((async) {
        var calls = 0;
        final (dio, adapter, waits) = buildRetryDio(
          handler: (options) async {
            calls++;
            if (calls < 4) {
              return FakeDioAdapter.jsonBytes(
                internalErrorEnvelope,
                status: 500,
              );
            }
            return FakeDioAdapter.jsonBytes(triageEnvelope);
          },
          wait: Future<void>.delayed,
        );

        Object? result;
        Object? error;
        dio.post<dynamic>('/triage', data: const {'symptoms': 'জ্বর'}).then(
          (v) => result = v.data,
          onError: (Object e) => error = e,
        );

        async
          ..flushMicrotasks()
          ..elapse(const Duration(seconds: 5))
          ..elapse(const Duration(seconds: 15))
          ..elapse(const Duration(seconds: 30))
          ..flushMicrotasks();

        expect(error, isNull);
        expect(result, isNotNull);
        expect(adapter.requests, hasLength(4));
        expect(waits, const [
          Duration(seconds: 5),
          Duration(seconds: 15),
          Duration(seconds: 30),
        ]);
      });
    });

    test('a 4xx is never retried, even during a transient outage', () async {
      final (dio, adapter, waits) = buildRetryDio(
        handler: (_) async =>
            FakeDioAdapter.jsonBytes(validationErrorEnvelope, status: 422),
        wait: immediateWait,
      );

      Object? result;
      Object? error;
      await dio.post<dynamic>('/triage', data: const {'symptoms': 'যা'}).then(
        (v) => result = v.data,
        onError: (Object e) => error = e,
      );

      expect(result, isNull);
      expect(error, isNotNull);
      expect(error, isA<DioException>());
      expect((error! as DioException).response?.statusCode, 422);
      expect(waits, isEmpty);
      // Only the initial attempt — the retry interceptor steps aside.
      expect(adapter.requests, hasLength(1));
    });

    test('a persistent 429 surfaces the API error after three retries',
        () async {
      final (dio, adapter, waits) = buildRetryDio(
        handler: (_) async =>
            FakeDioAdapter.jsonBytes(rateLimitedEnvelope, status: 429),
        wait: immediateWait,
      );

      Object? result;
      Object? error;
      await dio.post<dynamic>('/triage', data: const {'symptoms': 'বুকে ব্যথা'}).then(
        (v) => result = v.data,
        onError: (Object e) => error = e,
      );

      expect(result, isNull);
      expect(error, isNotNull);
      expect(error, isA<DioException>());
      expect((error! as DioException).response?.statusCode, 429);
      expect(adapter.requests, hasLength(4));
      expect(waits, const [
        Duration(seconds: 5),
        Duration(seconds: 15),
        Duration(seconds: 30),
      ]);
    });
  });
}
