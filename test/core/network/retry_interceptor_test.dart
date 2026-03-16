import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/network/retry_interceptor.dart';

// ─── Fake HTTP adapter ────────────────────────────────────────────────────────

typedef _FetchFn = Future<ResponseBody> Function(int callIndex);

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._onFetch);

  final _FetchFn _onFetch;
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    final index = callCount;
    callCount++;
    return _onFetch(index);
  }

  @override
  void close({bool force = false}) {}
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Dio _buildDio({
  required _FetchFn onFetch,
  List<Duration>? delayCapture,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
  final adapter = _FakeAdapter(onFetch);
  dio.httpClientAdapter = adapter;

  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      delayOverride: delayCapture != null
          ? (d) async => delayCapture.add(d)
          : (d) async {}, // no-op in tests
    ),
  );

  return dio;
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('RetryInterceptor — shouldRetry()', () {
    late RetryInterceptor interceptor;

    setUp(() {
      interceptor = RetryInterceptor(dio: Dio());
    });

    test('returns true for connectionError', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );
      expect(interceptor.shouldRetry(err), isTrue);
    });

    test('returns true for receiveTimeout', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.receiveTimeout,
      );
      expect(interceptor.shouldRetry(err), isTrue);
    });

    test('returns true for 500 server error', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 500,
        ),
      );
      expect(interceptor.shouldRetry(err), isTrue);
    });

    test('returns true for 503 server error', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 503,
        ),
      );
      expect(interceptor.shouldRetry(err), isTrue);
    });

    test('returns false for 404 client error', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 404,
        ),
      );
      expect(interceptor.shouldRetry(err), isFalse);
    });

    test('returns false for 400 bad request', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 400,
        ),
      );
      expect(interceptor.shouldRetry(err), isFalse);
    });
  });

  group('RetryInterceptor — retry behavior', () {
    test('succeeds without retrying on 200 response', () async {
      final dio = _buildDio(
        onFetch: (_) async => ResponseBody.fromString('ok', 200),
      );

      final response = await dio.get<String>('/test');

      expect(response.statusCode, 200);
      expect((dio.httpClientAdapter as _FakeAdapter).callCount, 1);
    });

    test('does not retry on 4xx error', () async {
      final dio = _buildDio(
        onFetch: (_) async => ResponseBody.fromString('not found', 404),
      );

      try {
        await dio.get<String>('/test');
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }

      expect((dio.httpClientAdapter as _FakeAdapter).callCount, 1);
    });

    test('retries 3 times then throws after all 500 failures', () async {
      final dio = _buildDio(
        onFetch: (_) async => ResponseBody.fromString('server error', 500),
      );

      try {
        await dio.get<String>('/test');
        fail('Expected DioException');
      } on DioException catch (e) {
        // After all retries exhausted, error should contain ServerException
        expect(e.error, isA<ServerException>());
        final serverEx = e.error as ServerException;
        expect(serverEx.statusCode, 500);
      }

      // 1 initial request + 3 retry attempts = 4 total
      expect((dio.httpClientAdapter as _FakeAdapter).callCount, 4);
    });

    test('recovers on the 2nd retry (3rd total attempt)', () async {
      final dio = _buildDio(
        onFetch: (index) async {
          // index 0 = initial, index 1 = retry 1, index 2 = retry 2 (succeeds)
          if (index < 2) return ResponseBody.fromString('error', 500);
          return ResponseBody.fromString('ok', 200);
        },
      );

      final response = await dio.get<String>('/test');

      expect(response.statusCode, 200);
      expect((dio.httpClientAdapter as _FakeAdapter).callCount, 3);
    });

    test('exponential backoff delays are 1s, 2s, 4s', () async {
      final delays = <Duration>[];

      final dio = _buildDio(
        onFetch: (_) async => ResponseBody.fromString('server error', 500),
        delayCapture: delays,
      );

      try {
        await dio.get<String>('/test');
      } on DioException {
        // expected
      }

      expect(delays, [
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 2000),
        const Duration(milliseconds: 4000),
      ]);
    });

    test('stops retrying when a non-retryable error occurs during retry', () async {
      final dio = _buildDio(
        onFetch: (index) async {
          if (index == 0) return ResponseBody.fromString('server error', 500);
          // On the first retry, return a 404 (non-retryable)
          return ResponseBody.fromString('not found', 404);
        },
      );

      try {
        await dio.get<String>('/test');
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }

      // 1 initial + 1 retry (stopped on 404) = 2 total
      expect((dio.httpClientAdapter as _FakeAdapter).callCount, 2);
    });
  });
}
