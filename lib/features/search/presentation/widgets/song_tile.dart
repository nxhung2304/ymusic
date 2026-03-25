import 'package:flutter/material.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

class SongTile extends StatelessWidget {
  static const double _thumbnailSize = 48;
  static const double _thumbnailBorderRadius = 4;

  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const SongTile({required this.song, this.onTap, this.onMoreTap, super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(_thumbnailBorderRadius),
        child: Image.network(
          song.thumbnailUrl,
          width: _thumbnailSize,
          height: _thumbnailSize,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: _thumbnailSize,
            height: _thumbnailSize,
            color: AppColors.surface,
            child: const Icon(Icons.music_note),
          ),
        ),
      ),
      onTap: onTap,
      title: Text(
        song.title,
        style: AppTypography.body.copyWith(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_formatDuration(song.duration)),
          IconButton(onPressed: onMoreTap, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}
