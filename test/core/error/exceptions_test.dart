import 'package:flutter_test/flutter_test.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/error/failures.dart';

void main() {
  group('AppExceptionMapper.toFailure()', () {
    test('NetworkException maps to NetworkFailure', () {
      const exception = NetworkException('no internet');

      final failure = exception.toFailure();

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'no internet');
    });

    test('ServerException maps to ServerFailure with statusCode', () {
      const exception = ServerException(statusCode: 503, message: 'unavailable');

      final failure = exception.toFailure();

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 503);
      expect(failure.message, 'unavailable');
    });

    test('UnauthorizedException maps to UnauthorizedFailure', () {
      const exception = UnauthorizedException('token expired');

      final failure = exception.toFailure();

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'token expired');
    });

    test('NotFoundException maps to NotFoundFailure', () {
      const exception = NotFoundException('song not found');

      final failure = exception.toFailure();

      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'song not found');
    });

    test('TimeoutException maps to TimeoutFailure', () {
      const exception = TimeoutException('read timeout');

      final failure = exception.toFailure();

      expect(failure, isA<TimeoutFailure>());
      expect(failure.message, 'read timeout');
    });

    test('CacheException maps to CacheFailure', () {
      const exception = CacheException('disk full');

      final failure = exception.toFailure();

      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'disk full');
    });

    test('UnknownException maps to UnknownFailure', () {
      const exception = UnknownException('unexpected');

      final failure = exception.toFailure();

      expect(failure, isA<UnknownFailure>());
      expect(failure.message, 'unexpected');
    });

    test('default messages are preserved when none provided', () {
      const networkFailure = NetworkException();
      const serverException = ServerException(statusCode: 500);
      const unauthorizedException = UnauthorizedException();
      const notFoundException = NotFoundException();
      const timeoutException = TimeoutException();
      const cacheException = CacheException();
      const unknownException = UnknownException();

      expect(networkFailure.toFailure().message, isNotEmpty);
      expect(serverException.toFailure().message, isNotEmpty);
      expect(unauthorizedException.toFailure().message, isNotEmpty);
      expect(notFoundException.toFailure().message, isNotEmpty);
      expect(timeoutException.toFailure().message, isNotEmpty);
      expect(cacheException.toFailure().message, isNotEmpty);
      expect(unknownException.toFailure().message, isNotEmpty);
    });
  });
}
