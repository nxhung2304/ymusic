import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/features/auth/data/datasources/auth_datasource.dart';
import 'package:ymusic/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ymusic/features/auth/domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthDatasource authDatasource(Ref ref) {
  return AuthDatasource();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authDatasourceProvider));
}

@Riverpod(keepAlive: true)
Stream<User?> authState(Ref ref) {
  return ref.watch(authDatasourceProvider).authStateChanges;
}
