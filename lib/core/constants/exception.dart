// lib/core/exceptions/api_exception.dart
class ApiException implements Exception {
  /// A user/developer-readable message
  final String message;

  /// The type of error: bad_request, unauthorized, etc.
  final String type;

  const ApiException(this.message, this.type);

  /// 400 - Bad Request
  factory ApiException.badRequest(String message) =>
      ApiException(message, 'bad_request');

  /// 401 - Unauthorized
  factory ApiException.unauthorized(String message) =>
      ApiException(message, 'unauthorized');

  /// 500 - Internal Server Error
  factory ApiException.serverError(String message) =>
      ApiException(message, 'server_error');

  /// Network-related failures
  factory ApiException.network(String message) =>
      ApiException(message, 'network');

  /// Unknown/other errors
  factory ApiException.unknown(String message) =>
      ApiException(message, 'unknown');

  @override
  String toString() => 'ApiException: $message (type: $type)';
}
