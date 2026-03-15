import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_provider.dart';
import 'package:ymusic/features/auth/presentation/screens/login_screen.dart';
import 'package:ymusic/features/auth/presentation/strings/auth_strings.dart';

const _kSplashTimeoutSeconds = 5;
const _kFadeAnimationDurationMs = 800;
const _kTransitionDurationMs = 400;
const _kMinSplashDisplayMs = 2000;

const _kIconSize = 72.0;
const _kGlowSize = 200.0;
const _kGlowBlurSigma = 40.0;
const _kDotSize = 6.0;
const _kAppNameFontSize = 42.0;
const _kAppNameLetterSpacing = -1.0;
const _kTaglineFontSize = 16.0;
const _kElementSpacing = 16.0;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _listenToAuthState();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kFadeAnimationDurationMs),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  void _listenToAuthState() {
    _timeoutTimer = Timer(
      const Duration(seconds: _kSplashTimeoutSeconds),
      () => _navigateToLogin(),
    );

    Future.wait([
      ref.read(authStateProvider.future),
      Future.delayed(const Duration(milliseconds: _kMinSplashDisplayMs)),
    ]).then((_) {
      if (!mounted) return;
      _cancelTimeout();
      // TODO(1.5): Replace with go_router navigation to /home when router is set up
      _navigateToLogin();
    }).catchError((_) {
      if (!mounted) return;
      _cancelTimeout();
      _navigateToLogin();
    });
  }

  void _cancelTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: _kTransitionDurationMs),
      ),
    );
  }

  @override
  void dispose() {
    _cancelTimeout();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildBackground(),
        _buildGlow(),
        Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildBranding(),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.2),
          radius: 1.0,
          colors: [
            AppColors.splashGradientTop,
            AppColors.splashGradientMid,
            AppColors.background,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildGlow() {
    return Center(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: _kGlowBlurSigma,
          sigmaY: _kGlowBlurSigma,
        ),
        child: Container(
          width: _kGlowSize,
          height: _kGlowSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.splashGlowColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBranding() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(),
        const SizedBox(height: _kElementSpacing),
        _buildAppName(),
        const SizedBox(height: _kElementSpacing),
        _buildTagline(),
        const SizedBox(height: _kElementSpacing),
        _buildDot(),
      ],
    );
  }

  Widget _buildIcon() {
    return const Icon(
      Icons.music_note_rounded,
      color: AppColors.splashIconColor,
      size: _kIconSize,
    );
  }

  Widget _buildAppName() {
    return const Text(
      AuthStrings.appName,
      style: TextStyle(
        fontSize: _kAppNameFontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: _kAppNameLetterSpacing,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildTagline() {
    return const Text(
      AuthStrings.splashDesc,
      style: TextStyle(
        fontSize: _kTaglineFontSize,
        color: AppColors.splashTaglineColor,
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: _kDotSize,
      height: _kDotSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.splashDotColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.splashDotGlowColor,
            blurRadius: 8,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }
}
