/// Typed exception carrying the API's own error code and its already-Bangla
/// message. Feature code only ever sees this shape — never the raw envelope.
class ApiException implements Exception {
  const ApiException(this.code, this.message, {this.statusCode});

  /// The `code` field from the API error envelope (e.g. `validation_failed`).
  final String code;

  /// `error.message` from the API — already Bangla, shown verbatim.
  final String message;

  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode $code): $message';
}
