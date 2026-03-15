import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  // Google "G" logo SVG — official Google colors
  static const String _googleLogoSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"/>
    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
  </svg>''';

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('[LoginScreen] Clicked to _handleGoogleSignIn button');
      final authDatasource = ref.read(authDatasourceProvider);
      final user = await authDatasource.signInWithGoogle();

      debugPrint("[LoginScreen] user = $user");
      // Navigation handled by go_router via authStateProvider
    } catch (e, stackTrace) {
      debugPrint('[LoginScreen] Google Sign In error: $e');
      debugPrint('[LoginScreen] StackTrace: $stackTrace');

      if (!mounted) return;

      if (e.toString().contains('Sign in cancelled')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AuthStrings.signInCancelled)),
        );
        return;
      }

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
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 1.2,
          colors: [
            AppColors.loginGradientPrimary,
            AppColors.loginGradientSecondary,
            AppColors.loginGradientTertiary,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.45),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.loginGlowPurple.withValues(alpha: 0.2),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),
            _buildLogoSection(),
            const Spacer(),
            _buildActionsSection(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return const Column(
      children: [
        Icon(
          Icons.music_note,
          size: 56,
          color: AppColors.loginIconLight,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          AuthStrings.appName,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
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
        const Text(
          AuthStrings.termsAndPrivacy,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.subtext,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildGoogleSignInButton(),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
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
                  borderRadius: BorderRadius.circular(26),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.string(
                      _googleLogoSvg,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    AuthStrings.continueWithGoogle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
