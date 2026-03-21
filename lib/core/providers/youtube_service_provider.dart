import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/services/youtube_service.dart';
import 'package:ymusic/core/utils/request_queue.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'youtube_service_provider.g.dart';

@riverpod
YoutubeExplode youtubeExplode(Ref ref) {
  final yt = YoutubeExplode();
  ref.onDispose(yt.close);
  return yt;
}

@riverpod
RequestQueue requestQueue(Ref ref) {
  return RequestQueue();
}

@riverpod
YouTubeService youTubeService(Ref ref) {
  return YouTubeService(
    ref.watch(youtubeExplodeProvider),
    ref.watch(requestQueueProvider),
  );
}
