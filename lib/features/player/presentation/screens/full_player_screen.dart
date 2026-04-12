import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/core/utils/duration_formatter.dart';
import 'package:ymusic/features/player/presentation/providers/player_notifier.dart';
import 'package:ymusic/features/player/presentation/providers/player_provider.dart';
import 'package:ymusic/features/player/presentation/strings/player_strings.dart';
import 'package:ymusic/features/player/presentation/widgets/player_artwork.dart';
import 'package:ymusic/features/player/presentation/widgets/player_controls.dart';
import 'package:ymusic/features/player/presentation/widgets/player_secondary_controls.dart';
import 'package:ymusic/features/player/presentation/widgets/player_seek_bar.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

class FullPlayerScreen extends ConsumerWidget {
  final String? videoId;

  const FullPlayerScreen({this.videoId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);
    final currentSong = playerState.currentSong;

    if (currentSong == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('No song currently playing'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen blur background with centered artwork
          PlayerArtwork(thumbnailUrl: currentSong.thumbnailUrl),

          // Content overlay
          SafeArea(
            child: Column(
              children: [
                const _TopNav(),
                const Spacer(),
                _SongInfo(currentSong: currentSong),
                PlayerSeekBar(
                  value: playerState.progress,
                  currentTime: DurationFormatter.format(playerState.position),
                  totalTime: DurationFormatter.format(playerState.duration),
                  onChanged: (progress) {
                    ref.read(playerNotifierProvider.notifier).seekToPosition(progress);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                const PlayerControls(),
                const SizedBox(height: AppSpacing.sm),
                const PlayerSecondaryControls(),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  const _TopNav();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.icon,
              size: AppSpacing.xl,
            ),
          ),
          const Text(PlayerStrings.nowPlaying, style: AppTypography.body),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, color: AppColors.icon),
          ),
        ],
      ),
    );
  }
}

class _SongInfo extends StatelessWidget {
  final Song currentSong;

  const _SongInfo({required this.currentSong});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentSong.title,
                  style: AppTypography.h2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  currentSong.artist,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
