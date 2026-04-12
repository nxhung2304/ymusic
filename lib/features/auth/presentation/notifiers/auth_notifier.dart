import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/utils/app_logger.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_provider.dart';
import 'package:ymusic/features/auth/presentation/states/auth_state.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> signInWithGoogle() async {
    AppLogger.d('Starting Google sign in');
    state = const AuthState.loading();

    final result = await ref.read(authRepositoryProvider).signInWithGoogle();

    result.fold(
      (failure) {
        AppLogger.e('Sign in failed: ${failure.message}', failure);
        state = AuthState.error(failure);
      },
      (user) {
        AppLogger.i('Sign in successful for user: ${user.uid}');
        state = AuthState.success(user);
      },
    );
  }

  Future<void> signOutWithGoogle() async {
    AppLogger.d('Starting Google sign out');
    state = const AuthState.loading();

    final result = await ref.read(authRepositoryProvider).signOutWithGoogle();

    result.fold(
      (failure) {
        AppLogger.e('Sign out failed: ${failure.message}', failure);
        state = AuthState.error(failure);
      },
      (_) {
        AppLogger.i('Sign out successful');
        state = const AuthState.initial();
      },
    );
  }
}
