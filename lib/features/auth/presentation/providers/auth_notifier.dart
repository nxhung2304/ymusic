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
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.checkSession();

      state = switch (result) {
        Success(data: final user) => AsyncValue.data(user),
        Failure(failure: final failure) =>
          AsyncValue.error(failure, StackTrace.current),
      };
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.signInWithGoogle();

      state = switch (result) {
        Success(:final data) => AsyncValue.data(data),
        Failure(:final failure) =>
          AsyncValue.error(failure, StackTrace.current),
      };
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.signOut();

      switch (result) {
        case Success():
          state = const AsyncValue.data(null);
        case Failure(:final failure):
          state = AsyncValue.error(failure, StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref);
});
