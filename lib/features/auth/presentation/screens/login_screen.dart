// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_provider.dart';
import 'package:ymusic/features/auth/presentation/strings/auth_strings.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final authDatasource = ref.read(authDatasourceProvider);
      await authDatasource.signInWithGoogle();
      // Navigation handled by go_router via authStateProvider
    } catch (e) {
      if (!mounted) return;

      // Handle user cancellation
      if (e.toString().contains('Sign in cancelled')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AuthStrings.signInCancelled)),
        );
        return;
      }

      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getErrorMessage(e))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();
    if (errorString.contains('network')) {
      return AuthStrings.networkError;
    }
    if (errorString.contains('firebase')) {
      return AuthStrings.authenticationFailed;
    }
    return '${AuthStrings.signInFailedPrefix}${error.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBackground(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildBackground({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.3, 0.3),
          radius: 1.4,
          colors: [
            AppColors.loginGradientPrimary.withValues(alpha: 0.3),
            AppColors.loginGradientSecondary,
            AppColors.loginGradientTertiary,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Glassmorphism glow
          Positioned(
            top: AppSpacing.xxl * 2 + AppSpacing.lg, // 80
            left: AppSpacing.xxl + AppSpacing.lg + AppSpacing.md, // 64
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.loginGlowPurple.withValues(alpha: 0.18),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl + AppSpacing.lg,
        ),
        child: Column(
          children: [
            _buildLogoSection(),
            SizedBox(height: AppSpacing.xxl + AppSpacing.lg),
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Icon(
          Icons.music_note,
          size: 56,
          color: AppColors.loginIconLight,
        ),
        SizedBox(height: AppSpacing.md - AppSpacing.sm), // 12
        Text(
          AuthStrings.appName,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: AppSpacing.md - AppSpacing.sm - AppSpacing.sm), // 8
        Text(
          AuthStrings.appTagline,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.loginTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        _buildGoogleSignInButton(),
        SizedBox(height: AppSpacing.md),
        Text(
          AuthStrings.termsAndPrivacy,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.subtext,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    const double buttonHeight = 52;
    const double buttonBorderRadius = 26;
    const double iconSize = 20;
    const double iconSpacing = 10;
    const double buttonTextSize = 16;
    const double buttonVerticalPadding = 14;
    const double buttonHorizontalPadding = 16;

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.googleBlue.withValues(alpha: 0.8),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _handleGoogleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonBorderRadius),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: buttonVerticalPadding,
                  horizontal: buttonHorizontalPadding,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.public,
                    color: AppColors.googleBlue,
                    size: iconSize,
                  ),
                  SizedBox(width: iconSpacing),
                  Text(
                    AuthStrings.continueWithGoogle,
                    style: const TextStyle(
                      fontSize: buttonTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
