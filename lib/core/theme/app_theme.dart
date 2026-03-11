import 'package:flutter/material.dart';

import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.text,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.text,
          elevation: 0,
          titleTextStyle: AppTypography.h3,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTypography.h1,
          displayMedium: AppTypography.h2,
          displaySmall: AppTypography.h3,
          bodyLarge: AppTypography.body,
          bodyMedium: AppTypography.body,
          bodySmall: AppTypography.caption,
          labelSmall: AppTypography.label,
        ),
        dividerColor: AppColors.divider,
        iconTheme: const IconThemeData(color: AppColors.icon),
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.surfaceLight,
          onSurface: AppColors.textLight,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          titleTextStyle: AppTypography.h3,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTypography.h1,
          displayMedium: AppTypography.h2,
          displaySmall: AppTypography.h3,
          bodyLarge: AppTypography.body,
          bodyMedium: AppTypography.body,
          bodySmall: AppTypography.caption,
          labelSmall: AppTypography.label,
        ),
        dividerColor: AppColors.dividerLight,
        iconTheme: const IconThemeData(color: AppColors.iconLight),
      );
}
