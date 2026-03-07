import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ymusic/router/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ymusic'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              context.goNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              authState.when(
                data: (user) {
                  if (user != null) {
                    return Column(
                      children: [
                        if (user.photoUrl != null)
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user.photoUrl!),
                          ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          user.displayName,
                          style: AppTypography.h2,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          user.email,
                          style: AppTypography.body,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('TODO: Implement Home Screen features'),
            ],
          ),
        ),
      ),
    );
  }
}
