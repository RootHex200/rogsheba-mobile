import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A transport-level fake.
///
/// Canned bytes come back for any request, so everything above the socket —
/// envelope decoding, explicit UTF-8 handling and error mapping — stays real
/// and stays under test. The handler can block on an exernally-completed
/// future so tests can observe in-flight UI states.
class FakeDioAdapter implements HttpClientAdapter {
  FakeDioAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}

  static ResponseBody jsonBytes(Map<String, dynamic> json, {int status = 200}) {
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(json)),
      status,
      headers: const {
        'content-type': ['application/json; charset=utf-8'],
      },
    );
  }
}
