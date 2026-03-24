import 'package:flutter/material.dart';

import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_typography.dart';

/// Utility class for showing consistent snackbars across the app.
///
/// Requires a valid [BuildContext] with a [ScaffoldMessenger] ancestor.
///
/// Usage:
/// ```dart
/// AppSnackbar.success(context, 'Song added to playlist');
/// AppSnackbar.error(context, 'Failed to load track');
/// AppSnackbar.info(context, 'Downloading...');
/// AppSnackbar.warning(context, 'No internet connection');
/// ```
class AppSnackbar {
  AppSnackbar._();

  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      color: const Color(0xFF4CAF50),
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline,
      color: AppColors.error,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      color: AppColors.primary,
    );
  }

  static void warning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      color: const Color(0xFFFFA726),
    );
  }

  // ---------------------------------------------------------------------------

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.body,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
