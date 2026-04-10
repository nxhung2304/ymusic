import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ymusic/core/constants/app_colors.dart';

const double _artworkBorderRadius = 16;
const double _artworkWidthFraction = 0.80;
const double _overlayOpacity = 0.55;
const double _blurSigma = 20;
const double _shadowAlpha = 0.4;
const double _shadowBlurRadius = 32;
const double _shadowOffsetY = 12;
const double _placeholderIconSize = 64;

class PlayerArtwork extends StatelessWidget {
  final String thumbnailUrl;

  const PlayerArtwork({super.key, required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    final isValidUrl = Uri.tryParse(thumbnailUrl)?.hasAuthority ?? false;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred background
        if (isValidUrl)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
            child: CachedNetworkImage(
              imageUrl: thumbnailUrl,
              fit: BoxFit.cover,
            ),
          )
        else
          const ColoredBox(color: AppColors.background),

        // Dark overlay
        const ColoredBox(color: Color.fromRGBO(0, 0, 0, _overlayOpacity)),

        // Foreground artwork (centered, 80% width, rounded, shadow)
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth * _artworkWidthFraction;
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_artworkBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _shadowAlpha),
                      blurRadius: _shadowBlurRadius,
                      offset: const Offset(0, _shadowOffsetY),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_artworkBorderRadius),
                  child: isValidUrl
                      ? CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        )
                      : const ColoredBox(
                          color: AppColors.surfaceVariant,
                          child: Icon(
                            Icons.music_note,
                            size: _placeholderIconSize,
                            color: AppColors.iconMuted,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
