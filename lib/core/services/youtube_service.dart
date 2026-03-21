import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/features/search/data/models/song_model.dart';

part 'youtube_service.g.dart';

class YouTubeService {
  YouTubeService({YoutubeExplode? yt})
      : _client = _YoutubeExplodeClient(yt ?? YoutubeExplode());

  @visibleForTesting
  YouTubeService.withClient(YouTubeSearchClient client) : _client = client;

  final YouTubeSearchClient _client;

  Future<List<SongModel>> search(String query) async {
    try {
      final videos = await _client.searchVideos(query);

      return videos.map(_toSongModel).toList();
    } on YouTubeException {
      rethrow;
    } catch (e) {
      throw YouTubeException('Search failed for query: "$query"', cause: e);
    }
  }

  SongModel _toSongModel(Video video) {
    if (video.duration == null) {
      dev.log(
        'duration is null for video ${video.id.value}',
        name: 'YouTubeService',
      );
    }

    return SongModel(
      videoId: video.id.value,
      title: video.title,
      artist: video.author,
      thumbnailUrl: video.thumbnails.highResUrl,
      duration: video.duration ?? Duration.zero,
    );
  }
}

@riverpod
YouTubeService youTubeService(Ref ref) => YouTubeService();

// ─── Internal client abstraction ─────────────────────────────────────────────

/// Minimal interface over YouTube search operations.
///
/// Exists to decouple [YouTubeService] from [YoutubeExplode] so that tests
/// can inject hand-written fakes without requiring a live network call.
abstract interface class YouTubeSearchClient {
  Future<List<Video>> searchVideos(String query);
}

class _YoutubeExplodeClient implements YouTubeSearchClient {
  _YoutubeExplodeClient(this._yt);

  final YoutubeExplode _yt;

  @override
  Future<List<Video>> searchVideos(String query) async {
    final results = await _yt.search.search(query);

    return results.toList();
  }
}
