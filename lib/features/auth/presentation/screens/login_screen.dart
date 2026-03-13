import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_provider.dart';

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
          const SnackBar(content: Text('Sign in cancelled')),
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
      return 'Network error. Please check your connection.';
    }
    if (errorString.contains('firebase')) {
      return 'Authentication failed. Please try again.';
    }
    return 'Sign in failed: ${error.toString()}';
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
            const Color(0xFF2D1B69).withValues(alpha: 0.3),
            const Color(0xFF0F0A1E),
            const Color(0xFF0A0A0A),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Glassmorphism glow
          Positioned(
            top: 120,
            left: 60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withValues(alpha: 0.18),
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        child: Column(
          children: [
            _buildLogoSection(),
            const SizedBox(height: 80),
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    // ignore: prefer_const_constructors
    return Column(
      children: [
        const Icon(
          Icons.music_note,
          size: 56,
          color: Color(0xFFCE93FF),
        ),
        const SizedBox(height: 12),
        const Text(
          'Ymusic',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your personal music universe',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFFB3B3B3),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        _buildGoogleSignInButton(),
        const SizedBox(height: 16),
        const Text(
          'By continuing, you agree to our Terms of Service\nand Privacy Policy',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF808080),
          ),
        ),
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
                  const Color(0xFF4285F4).withValues(alpha: 0.8),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _handleGoogleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFFFF),
                foregroundColor: const Color(0xFF111111),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.public,
                    color: Color(0xFF4285F4),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Continue with Google',
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
