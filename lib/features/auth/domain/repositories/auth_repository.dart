import 'package:ymusic/core/errors/result.dart';
import 'package:ymusic/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Result<UserModel?>> checkSession();
  Future<Result<UserModel>> signInWithGoogle();
  Future<Result<void>> signOut();
}
