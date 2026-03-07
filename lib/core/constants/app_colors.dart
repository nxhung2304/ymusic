import 'package:flutter/material.dart';

/// YMusic color palette - all colors use dark mode as default
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1DB954); // Spotify green
  static const Color accent = Color(0xFFFF6B35);

  // Background colors
  static const Color background = Color(0xFF0F0F0F); // Almost black
  static const Color surface = Color(0xFF1E1E1E); // Dark grey
  static const Color surfaceLight = Color(0xFF2A2A2A); // Lighter grey

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB3B3B3); // Light grey
  static const Color textTertiary = Color(0xFF7B7B7B); // Medium grey

  // Status colors
  static const Color error = Color(0xFFFF4444);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Transparent variants
  static const Color overlay = Color(0x80000000); // 50% black overlay
  static const Color divider = Color(0xFF282828); // Divider color
}
