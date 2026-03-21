import 'dart:developer' as dev;

import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/utils/request_queue.dart';
import 'package:ymusic/features/search/data/models/song_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// ─── Abstractions (for testability) ──────────────────────────────────────────

abstract interface class YouTubeSearchClient {
  /// Returns videos only. Playlists/channels are excluded by the underlying API.
  Future<List<Video>> searchVideos(String query);
}

abstract interface class YouTubeStreamsClient {
  /// Returns audio stream URLs sorted by bitrate descending (highest quality first).
  Future<List<Uri>> getSortedAudioUrls(String videoId);
}

// ─── Production implementations ──────────────────────────────────────────────

class _ExplodeSearchClient implements YouTubeSearchClient {
  const _ExplodeSearchClient(this._yt);

  final YoutubeExplode _yt;

  @override
  Future<List<Video>> searchVideos(String query) async {
    // yt.search.search returns VideoSearchList — video-only, no playlists/channels
    final results = await _yt.search.search(query);

    return results.toList();
  }
}

class _ExplodeStreamsClient implements YouTubeStreamsClient {
  const _ExplodeStreamsClient(this._yt);

  final YoutubeExplode _yt;

  @override
  Future<List<Uri>> getSortedAudioUrls(String videoId) async {
    final manifest = await _yt.videos.streams.getManifest(videoId);
    final streams = manifest.audioOnly.toList()
      ..sort((a, b) => b.bitrate.compareTo(a.bitrate));

    return streams.map((s) => s.url).toList();
  }
}

class _NoOpStreamsClient implements YouTubeStreamsClient {
  @override
  Future<List<Uri>> getSortedAudioUrls(String videoId) {
    throw const YouTubeException(
      'Streams client not configured — provide streamsClient in withClient()',
    );
  }
}

// ─── Service ─────────────────────────────────────────────────────────────────

class YouTubeService {
  final YouTubeSearchClient _searchClient;
  final YouTubeStreamsClient _streamsClient;
  final RequestQueue queue;

  YouTubeService(YoutubeExplode yt, this.queue)
      : _searchClient = _ExplodeSearchClient(yt),
        _streamsClient = _ExplodeStreamsClient(yt);

  /// Testing constructor — inject fake/mock clients without needing YoutubeExplode.
  YouTubeService.withClient(
    YouTubeSearchClient searchClient, {
    YouTubeStreamsClient? streamsClient,
    RequestQueue? queue,
  })  : _searchClient = searchClient,
        _streamsClient = streamsClient ?? _NoOpStreamsClient(),
        queue = queue ?? RequestQueue();

  Future<List<SongModel>> search(String query) async {
    try {
      final videos = await _searchClient.searchVideos(query);

      return videos.map(_toSongModel).toList();
    } on YouTubeException {
      rethrow;
    } catch (e) {
      throw YouTubeException('Search failed for query: "$query"', cause: e);
    }
  }

  Future<String> extractAudioUrl(String videoId) async {
    return queue.enqueue(() => _doExtractAudioUrl(videoId));
  }

  Future<String> _doExtractAudioUrl(String videoId) async {
    try {
      final urls = await _streamsClient.getSortedAudioUrls(videoId);

      for (final uri in urls) {
        try {
          final url = uri.toString();

          if (url.isNotEmpty) return url;
        } catch (_) {
          continue;
        }
      }

      throw YouTubeException('No valid audio stream for videoId: $videoId');
    } on YouTubeException {
      rethrow;
    } catch (e) {
      throw YouTubeException(
        'Failed to extract audio url for videoId: $videoId',
        cause: e,
      );
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
