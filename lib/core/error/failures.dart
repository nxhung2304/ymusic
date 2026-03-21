import 'package:ymusic/core/error/exceptions.dart';

// ─── Domain-level failure hierarchy (pure Dart, no external dependencies) ────

sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

final class ServerFailure extends Failure {
  // ignore: use_super_parameters
  const ServerFailure({required this.statusCode, String message = 'Server error'})
      : super(message);

  final int statusCode;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}

final class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Sign-in was cancelled']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}
// ─── Mapper ──────────────────────────────────────────────────────────────────

extension AppExceptionMapper on AppException {
  Failure toFailure() => switch (this) {
        NetworkException e => NetworkFailure(e.message),
        ServerException e => ServerFailure(statusCode: e.statusCode, message: e.message),
        UnauthorizedException e => UnauthorizedFailure(e.message),
        NotFoundException e => NotFoundFailure(e.message),
        TimeoutException e => TimeoutFailure(e.message),
        CacheException e => CacheFailure(e.message),
        UnknownException e => UnknownFailure(e.message),
      };
}
