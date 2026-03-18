import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:ymusic/core/error/failures.dart';
import 'package:ymusic/features/auth/data/datasources/auth_datasource.dart';
import 'package:ymusic/features/auth/data/models/user_model.dart';
import 'package:ymusic/features/auth/domain/entities/user.dart';
import 'package:ymusic/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl(this.authDatasource);

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final firebaseUser = await authDatasource.signInWithGoogle();
      final user = UserModel.fromFirebaseUser(firebaseUser);

      return right(user);
    } catch (e) {
      return left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOutWithGoogle() async {
    try {
      await authDatasource.signOut();

      return right(null);
    } catch (e) {
      return left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is firebase_auth.FirebaseAuthException) {
      if (e.code == 'network-request-failed') {
        return const NetworkFailure();
      }

      return AuthFailure(e.message ?? 'Auth error');
    }

    if (e is AuthException) {
      if (e.message.contains('cancelled')) {
        return const CancelledFailure();
      }

      return AuthFailure(e.message);
    }

    return AuthFailure(e.toString());
  }
}
