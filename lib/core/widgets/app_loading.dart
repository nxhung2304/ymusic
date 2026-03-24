import 'package:flutter/material.dart';

import 'package:ymusic/core/constants/app_colors.dart';

/// Centered circular loading indicator.
///
/// Usage in a widget tree:
/// ```dart
/// if (isLoading) const AppLoading()
/// ```
class AppLoading extends StatelessWidget {
  const AppLoading({this.color, this.size = 32, super.key});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Full-screen loading overlay. Blocks interaction while loading.
///
/// Usage:
/// ```dart
/// AppLoadingOverlay.show(context);
/// AppLoadingOverlay.hide(context);
/// ```
class AppLoadingOverlay {
  AppLoadingOverlay._();

  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (_) => const ColoredBox(
        color: Color(0x80000000),
        child: AppLoading(),
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  static void hide(BuildContext context) {
    _entry?.remove();
    _entry = null;
  }
}
