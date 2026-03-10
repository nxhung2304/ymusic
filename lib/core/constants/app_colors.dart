import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1DB954); // Spotify green
  static const Color primaryDark = Color(0xFF1aa34a);
  static const Color primaryLight = Color(0xFF1ed760);

  // Accent colors
  static const Color accent = Color(0xFFB91C8C);

  // Neutral colors
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF191919);
  static const Color surfaceVariant = Color(0xFF282828);
  static const Color surfaceLight = Color(0xFF333333);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF7A7A7A);

  // Status colors
  static const Color success = Color(0xFF1DB954);
  static const Color error = Color(0xFFE22134);
  static const Color warning = Color(0xFFFFA500);
  static const Color info = Color(0xFF1E90FF);

  // Overlay
  static const Color scrim = Color(0x80000000);
  static const Color shadow = Color(0x33000000);
}
