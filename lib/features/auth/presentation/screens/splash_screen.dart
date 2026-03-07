import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ymusic/router/app_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      // Navigate based on auth state
      next.when(
        data: (user) {
          if (user != null) {
            context.goNamed(AppRoutes.home);
          } else {
            context.goNamed(AppRoutes.login);
          }
        },
        error: (error, stackTrace) {
          // Redirect to login on error
          context.goNamed(AppRoutes.login);
        },
        loading: () {
          // Still loading, stay on splash
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // TODO: Add app logo/branding here
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
