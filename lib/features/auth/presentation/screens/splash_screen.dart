import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionCheck = ref.watch(checkSessionProvider);

    return sessionCheck.when(
      data: (user) {
        // Session exists, auto-login
        // Navigate to home screen
        Future.microtask(() {
          // TODO: Navigate to home screen when ready
          // For now, show the session exists
        });

        return const _SplashContent();
      },
      loading: () {
        return const _SplashContent();
      },
      error: (error, stackTrace) {
        // No session, show login screen
        Future.microtask(() {
          // Session check failed, user needs to login
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        });
        return const _SplashContent();
      },
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo/icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Y',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // App name
            Text(
              'YMusic',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Loading indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
