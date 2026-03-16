import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current error message to display. null = no error.
final errorMessageProvider = StateProvider<String?>((ref) => null);

/// Widget that listens to [errorMessageProvider] and shows a [SnackBar].
///
/// Mount this once inside [AppShell] to provide global error display.
class ErrorSnackbarListener extends ConsumerWidget {
  const ErrorSnackbarListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(errorMessageProvider, (previous, next) {
      if (next == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(next),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Clear after scheduling so the snackbar message is preserved
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(errorMessageProvider.notifier).state = null;
      });
    });

    return child;
  }
}
