import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ymusic/features/auth/data/services/auth_service.dart';
import 'package:ymusic/features/auth/domain/repositories/auth_repository.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService: service);
});
