import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ymusic/core/constants/app_assets.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:ymusic/features/auth/presentation/states/auth_state.dart';
import 'package:ymusic/features/auth/presentation/strings/auth_strings.dart';

// ─── Layout constants ─────────────────────────────────────────────────────────

const _kGradientCenter = Alignment(0, -0.3);
const _kGradientRadius = 1.2;
const _kGradientStops = [0.0, 0.55, 1.0];

const _kGlowAlignment = Alignment(0, -0.45);
const _kGlowCircleSize = 300.0;
const _kGlowOpacity = 0.2;

const _kLogoIconSize = 56.0;
const _kAppNameFontSize = 36.0;
const _kAppNameLetterSpacing = -1.0;
const _kTaglineFontSize = 14.0;
const _kTermsFontSize = 11.0;

const _kSignInButtonHeight = 52.0;
const _kButtonBorderRadius = 26.0;
const _kButtonPaddingV = 14.0;
const _kGoogleLogoSize = 20.0;
const _kGoogleLogoGap = 10.0;
const _kButtonLabelFontSize = 16.0;

// ─────────────────────────────────────────────────────────────────────────────

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      next.whenOrNull(
        error: (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        ),
      );
    });

    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      initial: () => _buildMain(ref),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_) => _buildMain(ref),
      success: (_) => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildMain(WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: _kGradientCenter,
            radius: _kGradientRadius,
            colors: [
              AppColors.loginGradientPrimary,
              AppColors.loginGradientSecondary,
              AppColors.loginGradientTertiary,
            ],
            stops: _kGradientStops,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: _kGlowAlignment,
              child: Container(
                width: _kGlowCircleSize,
                height: _kGlowCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.loginGlowPurple.withValues(alpha: _kGlowOpacity),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),
                    const Column(
                      children: [
                        Icon(
                          Icons.music_note,
                          size: _kLogoIconSize,
                          color: AppColors.loginIconLight,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          AuthStrings.appName,
                          style: TextStyle(
                            fontSize: _kAppNameFontSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: _kAppNameLetterSpacing,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          AuthStrings.appTagline,
                          style: TextStyle(
                            fontSize: _kTaglineFontSize,
                            fontWeight: FontWeight.normal,
                            color: AppColors.loginTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        const Text(
                          AuthStrings.termsAndPrivacy,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _kTermsFontSize,
                            color: AppColors.subtext,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          height: _kSignInButtonHeight,
                          child: ElevatedButton(
                            onPressed: () => authNotifier.signInWithGoogle(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_kButtonBorderRadius),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: _kButtonPaddingV,
                                horizontal: AppSpacing.md,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: _kGoogleLogoSize,
                                  height: _kGoogleLogoSize,
                                  child: SvgPicture.string(
                                    AppAssets.googleLogoSvg,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: _kGoogleLogoGap),
                                const Text(
                                  AuthStrings.continueWithGoogle,
                                  style: TextStyle(
                                    fontSize: _kButtonLabelFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
