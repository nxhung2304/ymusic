import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/features/player/presentation/providers/player_notifier.dart';
import 'package:ymusic/features/player/presentation/providers/player_provider.dart';

const double _playButtonSize = 64;
const double _controlIconSize = 32;

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            ref.read(playerNotifierProvider.notifier).previous();
          },
          icon: const Icon(
            Icons.skip_previous,
            size: _controlIconSize,
            color: AppColors.icon,
          ),
        ),
        GestureDetector(
          onTap: () {
            ref.read(playerNotifierProvider.notifier).togglePlayback();
          },
          child: Container(
            width: _playButtonSize,
            height: _playButtonSize,
            decoration: BoxDecoration(
              color: AppColors.loginGlowPurple,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.loginGlowPurple.withValues(alpha: 0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              playerState.isPlaying ? Icons.pause : Icons.play_arrow,
              size: _controlIconSize,
              color: AppColors.onPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            ref.read(playerNotifierProvider.notifier).next();
          },
          icon: const Icon(
            Icons.skip_next,
            size: _controlIconSize,
            color: AppColors.icon,
          ),
        ),
      ],
    );
  }
}
