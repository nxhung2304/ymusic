import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/providers/youtube_service_provider.dart';
import 'package:ymusic/core/services/youtube_service.dart';
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
    state = const AuthState.loading();

    final result = await ref.read(authRepositoryProvider).signInWithGoogle();

    result.fold(
      (failure) => state = AuthState.error(failure),
      (user) => state = AuthState.success(user),
    );
  }

  Future<void> signOutWithGoogle() async {
    state = const AuthState.loading();

    final result = await ref.read(authRepositoryProvider).signOutWithGoogle();

    result.fold(
      (failure) => state = AuthState.error(failure),
      (_) => state = const AuthState.initial(),
    );
  }

  Future<void> foo() async {
    final youtubeService = ref.read(youTubeServiceProvider);

    final audioUrl = await youtubeService.extractAudioUrl("85N9vgmGqro");

    debugPrint("audioUrl = $audioUrl");
  }
}
