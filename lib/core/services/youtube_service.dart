import 'dart:developer' as dev;

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/features/search/data/models/song_model.dart';

class YouTubeService {
  YouTubeService(this._yt);

  final YoutubeExplode _yt;

  Future<List<SongModel>> search(String query) async {
    try {
      final results = await _yt.search.search(query);

      return results.map(_toSongModel).toList();
    } catch (e) {
      throw YouTubeException('Search failed for query: "$query"', cause: e);
    }
  }

  Future<String> extractAudioUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streams.getManifest(videoId);
      final sortedStreams =
          manifest.audioOnly.toList()
            ..sort((a, b) => b.bitrate.compareTo(a.bitrate));

      for (var stream in sortedStreams) {
        if (stream.url.toString().isNotEmpty) {
          return stream.url.toString();
        }
      }

      throw const YouTubeException("No audio available");
    } catch (e) {
      throw YouTubeException(
        'Failed to get audio URLs for: "$videoId"',
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
