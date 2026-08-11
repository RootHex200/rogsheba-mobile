import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/config/app_config_provider.dart';
import 'package:rogsheba_mobile/core/network/api_client.dart';

/// Composition root for the network layer.
///
/// [dioProvider] is the single seam a test overrides (with a Dio whose
/// `httpClientAdapter` is faked). Everything below — envelope decoding,
/// UTF-8 handling and error mapping — stays real so it is under test.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(configProvider);
  return Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      contentType: 'application/json; charset=utf-8',
      connectTimeout: config.defaultTimeout,
      receiveTimeout: config.defaultTimeout,
    ),
  );
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider), ref.watch(configProvider)),
);
