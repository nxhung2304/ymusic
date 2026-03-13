// ignore_for_file: deprecated_member_use_from_same_package

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/features/auth/data/datasources/auth_datasource.dart';

part 'auth_provider.g.dart';

/// Provides a singleton instance of [AuthDatasource]
@riverpod
AuthDatasource authDatasource(AuthDatasourceRef ref) {
  return AuthDatasource();
}

/// Provides a stream of auth state changes
/// Emits [User?] whenever authentication state changes (login/logout)
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return ref.watch(authDatasourceProvider).authStateChanges;
}

/// Provides the current authenticated user
/// Returns null if user is not logged in, otherwise returns the [User] object
@riverpod
User? currentUser(CurrentUserRef ref) {
  return ref.watch(authStateProvider).value;
}
