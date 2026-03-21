class FirestoreException implements Exception {
  const FirestoreException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'FirestoreException: $message${cause != null ? ' (cause: $cause)' : ''}';
}

class IsarException implements Exception {
  const IsarException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'IsarException: $message${cause != null ? ' (cause: $cause)' : ''}';
}

// ─── App-level exception hierarchy ───────────────────────────────────────────

sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

final class ServerException extends AppException {
  // ignore: use_super_parameters
  const ServerException({required this.statusCode, String message = 'Server error'})
      : super(message);

  final int statusCode;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

final class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

final class UnknownException extends AppException {
  const UnknownException([super.message = 'An unknown error occurred']);
}

final class YouTubeException extends AppException {
  const YouTubeException(super.message, {this.cause});

  final Object? cause;

  @override
  String toString() =>
      'YouTubeException: $message${cause != null ? ' (cause: $cause)' : ''}';
}
