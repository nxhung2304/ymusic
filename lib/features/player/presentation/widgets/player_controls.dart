import 'package:flutter/material.dart';
import 'package:ymusic/core/constants/app_colors.dart';

const double _playButtonSize = 64;
const double _controlIconSize = 32;

class PlayerControls extends StatefulWidget {
  const PlayerControls({super.key});

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  // TODO(3.8): Replace with playerStateProvider
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {}, // TODO(3.8): Wire prev to AudioPlayerService
          icon: const Icon(
            Icons.skip_previous,
            size: _controlIconSize,
            color: AppColors.icon,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _isPlaying = !_isPlaying),
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
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: _controlIconSize,
              color: AppColors.onPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: () {}, // TODO(3.8): Wire next to AudioPlayerService
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
