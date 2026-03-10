import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/data/services/auth_service.dart';
import 'package:ymusic/core/errors/failures.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

final authServiceProvider = Provider((ref) => AuthService());

/// Watch auth state changes
@riverpod
Stream<User?> authStateStream(Ref ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
}

/// Check session on app startup (one-time check)
@riverpod
Future<User?> checkSession(Ref ref) async {
  final authService = ref.watch(authServiceProvider);
  try {
    return await authService.checkSession();
  } catch (e) {
    // Session expired or invalid
    throw SessionExpiredFailure(e.toString());
  }
}

/// Current authenticated user
@riverpod
Stream<User?> currentUser(Ref ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
}

/// Sign in with Google
@riverpod
class SignInNotifier extends _$SignInNotifier {
  @override
  AsyncValue<User?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Sign out
@riverpod
class SignOutNotifier extends _$SignOutNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
