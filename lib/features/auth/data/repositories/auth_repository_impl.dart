import 'package:ymusic/core/errors/result.dart';
import 'package:ymusic/features/auth/data/models/user_model.dart';
import 'package:ymusic/features/auth/data/services/auth_service.dart';
import 'package:ymusic/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
  Future<Result<UserModel?>> checkSession() async {
    return authService.checkSession();
  }

  @override
  Future<Result<UserModel>> signInWithGoogle() async {
    return authService.signInWithGoogle();
  }

  @override
  Future<Result<void>> signOut() async {
    return authService.signOut();
  }
}
