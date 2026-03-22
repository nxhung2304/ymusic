import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/services/youtube_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'youtube_service_provider.g.dart';

@riverpod
YouTubeService youTubeService(Ref ref) => YouTubeService(YoutubeExplode());
