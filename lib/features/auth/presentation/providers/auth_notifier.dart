import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/errors/result.dart';
import 'package:ymusic/features/auth/data/models/user_model.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_service_provider.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      debugPrint('📱 [AuthNotifier] Initializing auth state...');
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.checkSession();

      switch (result) {
        case Success(data: final user):
          if (user != null) {
            debugPrint('✅ [AuthNotifier] User logged in: ${user.email}');
          } else {
            debugPrint('ℹ️  [AuthNotifier] No logged in user');
          }
          state = AsyncValue.data(user);
        case Failure(failure: final failure):
          debugPrint('❌ [AuthNotifier] Session check failed: ${failure.message}');
          state = AsyncValue.error(failure, StackTrace.current);
      }
    } catch (e, st) {
      debugPrint('❌ [AuthNotifier] Init error: $e');
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    debugPrint('🔐 [AuthNotifier] Starting sign in flow...');
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.signInWithGoogle();

      switch (result) {
        case Success(:final data):
          debugPrint('✅ [AuthNotifier] Sign in successful: ${data.email}');
          state = AsyncValue.data(data);
        case Failure(:final failure):
          debugPrint('❌ [AuthNotifier] Sign in failed: ${failure.message}');
          state = AsyncValue.error(failure, StackTrace.current);
      }
    } catch (e, st) {
      debugPrint('❌ [AuthNotifier] Sign in exception: $e');
      debugPrint('Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    debugPrint('🚪 [AuthNotifier] Starting sign out...');
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.signOut();

      switch (result) {
        case Success():
          debugPrint('✅ [AuthNotifier] Sign out successful');
          state = const AsyncValue.data(null);
        case Failure(:final failure):
          debugPrint('❌ [AuthNotifier] Sign out failed: ${failure.message}');
          state = AsyncValue.error(failure, StackTrace.current);
      }
    } catch (e, st) {
      debugPrint('❌ [AuthNotifier] Sign out exception: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref);
});
