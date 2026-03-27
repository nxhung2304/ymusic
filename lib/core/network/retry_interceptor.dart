import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/utils/app_logger.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    int maxRetries = _kMaxRetries,
    int baseDelayMs = _kBaseDelayMs,
    @visibleForTesting Future<void> Function(Duration)? delayOverride,
  }) : _dio = dio,
       _maxRetries = maxRetries,
       _baseDelayMs = baseDelayMs,
       _delay = delayOverride ?? _defaultDelay;

  final Dio _dio;
  final int _maxRetries;
  final int _baseDelayMs;
  final Future<void> Function(Duration) _delay;

  static const int _kMaxRetries = 3;
  static const int _kBaseDelayMs = 1000;
  static const String _kIsRetryKey = 'isRetry';

  static Future<void> _defaultDelay(Duration duration) =>
      Future<void>.delayed(duration);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Prevent re-entry for requests already being retried
    if (err.requestOptions.extra[_kIsRetryKey] == true) {
      handler.next(err);
      return;
    }

    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    // Mark all subsequent fetch calls as retries to prevent recursion
    err.requestOptions.extra[_kIsRetryKey] = true;

    DioException lastError = err;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      final delayMs = _baseDelayMs * (1 << attempt); // 1000 → 2000 → 4000

      AppLogger.i('attempt ${attempt + 1}/$_maxRetries after ${delayMs}ms');

      await _delay(Duration(milliseconds: delayMs));

      try {
        final response = await _dio.fetch<dynamic>(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (retryErr) {
        lastError = retryErr;

        if (!_shouldRetry(retryErr)) {
          handler.next(retryErr);
          return;
        }
      }
    }

    // All retries exhausted — map to typed AppException
    final appException = _mapToAppException(lastError);

    handler.reject(
      DioException(
        requestOptions: lastError.requestOptions,
        response: lastError.response,
        type: lastError.type,
        error: appException,
        message: appException.message,
      ),
    );
  }

  @visibleForTesting
  bool shouldRetry(DioException err) => _shouldRetry(err);

  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionError) return true;
    if (err.type == DioExceptionType.receiveTimeout) return true;

    final statusCode = err.response?.statusCode;
    return statusCode != null && statusCode >= 500 && statusCode < 600;
  }

  AppException _mapToAppException(DioException err) {
    if (err.type == DioExceptionType.connectionError) {
      return NetworkException(err.message ?? 'Network error occurred');
    }

    if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      return TimeoutException(err.message ?? 'Request timed out');
    }

    final statusCode = err.response?.statusCode;
    if (statusCode != null) {
      return ServerException(
        statusCode: statusCode,
        message: err.message ?? 'Server error',
      );
    }

    return UnknownException(err.message ?? 'An unknown error occurred');
  }
}
