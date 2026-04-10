import 'package:flutter/material.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/features/player/presentation/strings/player_strings.dart';
import 'package:ymusic/features/player/presentation/widgets/player_artwork.dart';
import 'package:ymusic/features/player/presentation/widgets/player_controls.dart';
import 'package:ymusic/features/player/presentation/widgets/player_secondary_controls.dart';
import 'package:ymusic/features/player/presentation/widgets/player_seek_bar.dart';
import 'package:ymusic/features/search/data/models/song_model.dart';

// TODO(3.8): Replace with playerStateProvider
const _mockSong = SongModel(
  videoId: 'dQw4w9WgXcQ',
  title: 'Never Gonna Give You Up',
  artist: 'Rick Astley',
  thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
  duration: Duration(minutes: 3, seconds: 33),
);

const _mockProgress = 0.3;
const _mockCurrentTime = '1:00';
const _mockTotalTime = '3:33';

class FullPlayerScreen extends StatelessWidget {
  final String? videoId;

  const FullPlayerScreen({this.videoId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen blur background with centered artwork
          PlayerArtwork(thumbnailUrl: _mockSong.thumbnailUrl),

          // Content overlay
          const SafeArea(
            child: Column(
              children: [
                _TopNav(),
                Spacer(),
                _SongInfo(),
                PlayerSeekBar(
                  value: _mockProgress,
                  currentTime: _mockCurrentTime,
                  totalTime: _mockTotalTime,
                ),
                SizedBox(height: AppSpacing.sm),
                PlayerControls(),
                SizedBox(height: AppSpacing.sm),
                PlayerSecondaryControls(),
                SizedBox(height: AppSpacing.md),
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
  const _SongInfo();
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
                  _mockSong.title,
                  style: AppTypography.h2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _mockSong.artist,
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
