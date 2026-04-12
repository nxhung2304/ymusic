import 'package:flutter/material.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_typography.dart';

const double _inactiveTrackAlpha = 0.15;
const double _overlayAlpha = 0.2;
const double _trackHeight = 3;
const double _thumbRadius = 6;

class PlayerSeekBar extends StatefulWidget {
  final double value;
  final String currentTime;
  final String totalTime;
  final ValueChanged<double>? onChanged;

  const PlayerSeekBar({
    super.key,
    required this.value,
    required this.currentTime,
    required this.totalTime,
    this.onChanged,
  });

  @override
  State<PlayerSeekBar> createState() => _PlayerSeekBarState();
}

class _PlayerSeekBarState extends State<PlayerSeekBar> {
  double? _draggingValue;

  @override
  Widget build(BuildContext context) {
    // Use dragging value while user is interacting, otherwise use widget value
    final effectiveValue = _draggingValue ?? widget.value;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.loginGlowPurple,
            inactiveTrackColor: Colors.white.withValues(alpha: _inactiveTrackAlpha),
            thumbColor: Colors.white,
            overlayColor: AppColors.loginGlowPurple.withValues(alpha: _overlayAlpha),
            trackHeight: _trackHeight,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: _thumbRadius),
          ),
          child: Slider(
            value: effectiveValue.clamp(0.0, 1.0),
            min: 0,
            max: 1,
            onChanged: (v) {
              setState(() => _draggingValue = v);
              widget.onChanged?.call(v);
            },
            onChangeEnd: (_) {
              // Clear drag state to sync back with widget value
              setState(() => _draggingValue = null);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.currentTime, style: AppTypography.label),
              Text(widget.totalTime, style: AppTypography.label),
            ],
          ),
        ),
      ],
    );
  }
}
