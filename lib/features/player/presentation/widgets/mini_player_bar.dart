import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/core/router/app_router.dart';
import 'package:ymusic/features/search/data/models/song_model.dart';

// TODO(3.8): Replace with playerStateProvider
const _mockSong = SongModel(
  videoId: 'dQw4w9WgXcQ',
  title: 'Never Gonna Give You Up',
  artist: 'Rick Astley',
  thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
  duration: Duration(minutes: 3, seconds: 33),
);

const double _thumbnailSize = 48;
const double _thumbnailBorderRadius = 6;
const double _barHeight = 68;

class MiniPlayerBar extends StatefulWidget {
  const MiniPlayerBar({super.key});

  @override
  State<MiniPlayerBar> createState() => _MiniPlayerBarState();
}

class _MiniPlayerBarState extends State<MiniPlayerBar> {
  // TODO(3.8): Replace with playerStateProvider
  bool _isPlaying = true;
  bool _hasSong = true;

  @override
  Widget build(BuildContext context) {
    if (!_hasSong) return const SizedBox.shrink();

    final thumbnailUrl = _mockSong.thumbnailUrl;
    final isValidUrl = Uri.tryParse(thumbnailUrl)?.hasAuthority ?? false;

    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.player),
      child: ColoredBox(
        color: AppColors.surface,
        child: SizedBox(
          height: _barHeight,
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(_thumbnailBorderRadius),
                child: SizedBox(
                  width: _thumbnailSize,
                  height: _thumbnailSize,
                  child: isValidUrl
                      ? CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          fit: BoxFit.cover,
                        )
                      : const ColoredBox(
                          color: AppColors.surfaceVariant,
                          child: Icon(Icons.music_note, color: AppColors.iconMuted),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mockSong.title,
                      style: AppTypography.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _mockSong.artist,
                      style: AppTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: AppColors.icon,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _hasSong = false),
                icon: const Icon(Icons.close, color: AppColors.icon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
