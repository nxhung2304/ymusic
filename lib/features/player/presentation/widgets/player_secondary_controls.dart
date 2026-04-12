import 'package:flutter/material.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';

const double _secondaryIconSize = 22;

enum _RepeatMode { off, one, all }

class PlayerSecondaryControls extends StatefulWidget {
  const PlayerSecondaryControls({super.key});

  @override
  State<PlayerSecondaryControls> createState() => _PlayerSecondaryControlsState();
}

class _PlayerSecondaryControlsState extends State<PlayerSecondaryControls> {
  bool _shuffleActive = false;
  _RepeatMode _repeatMode = _RepeatMode.off;
  bool _liked = false;

  void _cycleRepeat() {
    setState(() {
      _repeatMode = switch (_repeatMode) {
        _RepeatMode.off => _RepeatMode.one,
        _RepeatMode.one => _RepeatMode.all,
        _RepeatMode.all => _RepeatMode.off,
      };
    });
  }

  IconData get _repeatIcon => switch (_repeatMode) {
        _RepeatMode.one => Icons.repeat_one,
        _ => Icons.repeat,
      };

  Color _activeColor(bool active) =>
      active ? AppColors.loginGlowPurple : AppColors.iconMuted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => setState(() => _shuffleActive = !_shuffleActive),
            icon: Icon(
              Icons.shuffle,
              size: _secondaryIconSize,
              color: _activeColor(_shuffleActive),
            ),
          ),
          IconButton(
            onPressed: _cycleRepeat,
            icon: Icon(
              _repeatIcon,
              size: _secondaryIconSize,
              color: _activeColor(_repeatMode != _RepeatMode.off),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _liked = !_liked),
            icon: Icon(
              _liked ? Icons.favorite : Icons.favorite_border,
              size: _secondaryIconSize,
              color: _liked ? AppColors.primary : AppColors.iconMuted,
            ),
          ),
        ],
      ),
    );
  }
}
