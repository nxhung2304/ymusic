import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/core/errors/failures.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ymusic/features/auth/presentation/strings/auth_strings.dart';
import 'package:ymusic/router/app_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          debugPrint('🎯 [LoginScreen] Navigating to home');
          context.goNamed(AppRoutes.home);
        }
      });

      next.maybeWhen(
        error: (error, stackTrace) {
          String message = AuthStrings.unknownError;
          if (error is AppFailure) {
            message = error.message;
          }
          debugPrint('⚠️  [LoginScreen] Showing error: $message');
          debugPrint('Error object: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome text
              Text(
                AuthStrings.welcome,
                style: AppTypography.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          ref.read(authNotifierProvider.notifier)
                              .signInWithGoogle();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          AuthStrings.signInWithGoogle,
                          style: AppTypography.buttonText,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
