import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_provider.dart';
import 'package:ymusic/features/auth/presentation/screens/login_screen.dart';
import 'package:ymusic/features/auth/presentation/strings/auth_strings.dart';

const _kSplashTimeoutSeconds = 5;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  StreamSubscription<dynamic>? _authSubscription;
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
      duration: const Duration(milliseconds: 800),
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

    final authStream = ref.read(authStateProvider.future);

    authStream.then((user) {
      if (!mounted) return;
      _cancelTimeout();

      if (user != null) {
        // TODO(1.5): Replace with go_router navigation to /home when router is set up
        _navigateToLogin();
      } else {
        _navigateToLogin();
      }
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
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _cancelTimeout();
    _authSubscription?.cancel();
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.loginGradientPrimary,
            AppColors.loginGradientSecondary,
            AppColors.loginGradientTertiary,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildBranding(),
        ),
      ),
    );
  }

  Widget _buildBranding() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogo(),
        const SizedBox(height: AppSpacing.md),
        _buildAppName(),
        const SizedBox(height: AppSpacing.sm),
        _buildTagline(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.music_note_rounded,
        color: AppColors.onPrimary,
        size: 44,
      ),
    );
  }

  Widget _buildAppName() {
    return Text(
      AuthStrings.appName,
      style: AppTypography.h1.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildTagline() {
    return const Text(
      AuthStrings.appTagline,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.loginTextSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}
