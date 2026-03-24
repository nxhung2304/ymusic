import 'package:flutter/material.dart';

import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_typography.dart';

/// Utility class for showing consistent dialogs across the app.
///
/// Usage:
/// ```dart
/// final confirmed = await AppDialog.confirm(
///   context,
///   title: 'Delete song',
///   message: 'Are you sure you want to remove this song?',
/// );
///
/// AppDialog.info(context, title: 'Done', message: 'Song added to playlist.');
/// ```
class AppDialog {
  AppDialog._();

  /// Shows a confirmation dialog. Returns `true` if user confirms, `false` otherwise.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _AppDialogWidget(
        title: title,
        message: message,
        actions: [
          _DialogAction(label: cancelLabel, value: false, isPrimary: false),
          _DialogAction(
            label: confirmLabel,
            value: true,
            isPrimary: true,
            isDangerous: isDangerous,
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Shows an info dialog with a single dismiss button.
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String dismissLabel = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => _AppDialogWidget(
        title: title,
        message: message,
        actions: [
          _DialogAction(label: dismissLabel, value: null, isPrimary: true),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal widgets
// ---------------------------------------------------------------------------

class _DialogAction<T> {
  const _DialogAction({
    required this.label,
    required this.value,
    required this.isPrimary,
    this.isDangerous = false,
  });

  final String label;
  final T value;
  final bool isPrimary;
  final bool isDangerous;
}

class _AppDialogWidget<T> extends StatelessWidget {
  const _AppDialogWidget({
    required this.title,
    required this.message,
    required this.actions,
    super.key,
  });

  final String title;
  final String message;
  final List<_DialogAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title, style: AppTypography.h3),
      content: Text(message, style: AppTypography.body),
      actions: actions.map(_buildAction).toList(),
    );
  }

  Widget _buildAction(_DialogAction<T> action) {
    return Builder(
      builder: (ctx) {
        final color = action.isDangerous
            ? AppColors.error
            : action.isPrimary
                ? AppColors.primary
                : AppColors.textSecondary;

        return TextButton(
          onPressed: () => Navigator.of(ctx).pop(action.value),
          child: Text(
            action.label,
            style: AppTypography.body.copyWith(
              color: color,
              fontWeight: action.isPrimary ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }
}
