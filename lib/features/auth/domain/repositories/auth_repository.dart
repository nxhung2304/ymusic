import 'package:fpdart/fpdart.dart';
import 'package:ymusic/core/error/failures.dart';
import 'package:ymusic/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> signOutWithGoogle();
}
