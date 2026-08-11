import 'package:dio/dio.dart';

/// The backoff schedule the API doc prescribes: wait 5s, then 15s, then 30s.
/// Three retry attempts in total for `429` and `5xx`.
const List<Duration> defaultRetryDelays = [
  Duration(seconds: 5),
  Duration(seconds: 15),
  Duration(seconds: 30),
];

/// True only for statuses the retry policy allows: `429` and `5xx`.
bool isRetryableStatus(int? statusCode) {
  if (statusCode == null) return false;
  return statusCode == 429 || statusCode >= 500;
}

/// Retries `429` and `5xx` responses on a fixed backoff and passes every other
/// failure straight through — a user who caused a `4xx` is told immediately
/// rather than waiting through a silent retry. Lives here, not in
/// repositories.
///
/// The delay itself is injected via [wait] (supplied through the provider
/// graph) rather than by calling `Future.delayed` directly, so retry timing is
/// testable without real waiting.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    required this.wait,
    this.retryDelays = defaultRetryDelays,
  });

  final Dio dio;
  final Future<void> Function(Duration) wait;
  final List<Duration> retryDelays;

  static const _attemptKey = 'rogsheba_retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (!isRetryableStatus(statusCode)) {
      return handler.next(err);
    }

    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;
    if (attempt >= retryDelays.length) {
      return handler.next(err);
    }

    options.extra[_attemptKey] = attempt + 1;
    await wait(retryDelays[attempt]);

    try {
      final response = await dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
