import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ymusic/core/router/app_router.dart';
import 'package:ymusic/features/player/presentation/providers/player_notifier.dart';
import 'package:ymusic/features/player/presentation/providers/player_provider.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);
    final currentSong = playerState.currentSong;

    if (currentSong == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.push(AppRoutes.player),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            // Album art
            _AlbumArt(thumbnailUrl: currentSong.thumbnailUrl),
            const SizedBox(width: 12),

            // Song info and seek bar
            Expanded(
              child: _SongInfo(
                title: currentSong.title,
                progress: playerState.progress,
                onSeek: (value) {
                  ref.read(playerNotifierProvider.notifier).seekToPosition(value);
                },
              ),
            ),

            // Play/Pause button (right-aligned like Spotify)
            _PlayPauseButton(
              isPlaying: playerState.isPlaying,
              onPressed: () {
                ref.read(playerNotifierProvider.notifier).togglePlayback();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  final String thumbnailUrl;

  const _AlbumArt({required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: thumbnailUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 56,
          height: 56,
          color: Colors.grey[300],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 56,
          height: 56,
          color: Colors.grey[300],
          child: const Icon(Icons.music_note, size: 24),
        ),
      ),
    );
  }
}

class _SongInfo extends StatelessWidget {
  final String title;
  final double progress;
  final ValueChanged<double> onSeek;

  const _SongInfo({
    required this.title,
    required this.progress,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        _SeekBar(progress: progress, onSeek: onSeek),
      ],
    );
  }
}

class _SeekBar extends StatefulWidget {
  final double progress;
  final ValueChanged<double> onSeek;

  const _SeekBar({required this.progress, required this.onSeek});

  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  double? _draggingProgress;

  @override
  void didUpdateWidget(_SeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear drag state when player position catches up to where we dragged
    if (_draggingProgress != null) {
      final diff = (_draggingProgress! - widget.progress).abs();
      // If the difference is small, player has caught up
      if (diff < 0.01) {
        _draggingProgress = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveProgress = _draggingProgress ?? widget.progress;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
      ),
      child: Slider(
        value: effectiveProgress.clamp(0.0, 1.0),
        onChanged: (value) {
          setState(() => _draggingProgress = value);
          widget.onSeek(value);
        },
        onChangeEnd: (_) {
          // Don't clear here - let didUpdateWidget handle it when player catches up
        },
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        size: 28,
      ),
      splashRadius: 24,
    );
  }
}
