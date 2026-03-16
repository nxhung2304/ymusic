import 'package:ymusic/core/error/exceptions.dart';

// ─── Domain-level failure hierarchy (pure Dart, no external dependencies) ────

sealed class AppFailure {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

final class ServerFailure extends AppFailure {
  // ignore: use_super_parameters
  const ServerFailure({required this.statusCode, String message = 'Server error'})
      : super(message);

  final int statusCode;
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

final class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}

// ─── Mapper ──────────────────────────────────────────────────────────────────

extension AppExceptionMapper on AppException {
  AppFailure toFailure() => switch (this) {
        NetworkException e => NetworkFailure(e.message),
        ServerException e => ServerFailure(statusCode: e.statusCode, message: e.message),
        UnauthorizedException e => UnauthorizedFailure(e.message),
        NotFoundException e => NotFoundFailure(e.message),
        TimeoutException e => TimeoutFailure(e.message),
        CacheException e => CacheFailure(e.message),
        UnknownException e => UnknownFailure(e.message),
      };
}
