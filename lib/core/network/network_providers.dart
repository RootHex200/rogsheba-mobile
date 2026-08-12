import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/config/app_config_provider.dart';
import 'package:rogsheba_mobile/core/network/api_client.dart';
import 'package:rogsheba_mobile/core/network/retry_interceptor.dart';

/// Composition root for the network layer.
///
/// [dioProvider] is the single seam a test overrides (with a Dio whose
/// `httpClientAdapter` is faked). Everything below — envelope decoding,
/// UTF-8 handling, error mapping and retry/backoff — stays real so it is
/// under test.
final retryDelayProvider = Provider<Future<void> Function(Duration)>(
  (ref) => Future<void>.delayed,
);

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(configProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      contentType: 'application/json; charset=utf-8',
      connectTimeout: config.defaultTimeout,
      receiveTimeout: config.defaultTimeout,
    ),
  );
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      wait: ref.watch(retryDelayProvider),
    ),
  );
  return dio;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider), ref.watch(configProvider)),
);
