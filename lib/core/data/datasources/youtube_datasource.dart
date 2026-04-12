import 'dart:developer' as dev;

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ymusic/core/data/models/song_model.dart';
import 'package:ymusic/core/error/exceptions.dart';

abstract class YouTubeSearchClient {
  Future<List<Video>> searchVideos(String query);
}

class _YoutubeExplodeSearchClient implements YouTubeSearchClient {
  _YoutubeExplodeSearchClient(this._yt);

  final YoutubeExplode _yt;

  @override
  Future<List<Video>> searchVideos(String query) async =>
      (await _yt.search.search(query)).toList();
}

class YouTubeDatasource {
  YouTubeDatasource(YoutubeExplode yt) : _searchClient = _YoutubeExplodeSearchClient(yt), _yt = yt;

  YouTubeDatasource.withClient(YouTubeSearchClient client) : _searchClient = client, _yt = null;

  final YouTubeSearchClient _searchClient;
  final YoutubeExplode? _yt;

  Future<List<SongModel>> search(String query) async {
    try {
      final results = await _searchClient.searchVideos(query);

      return results.map(_toSongModel).toList();
    } catch (e) {
      throw YouTubeException('Search failed for query: "$query"', cause: e);
    }
  }

  Future<String> extractAudioUrl(String videoId) async {
    try {
      dev.log('Getting manifest for $videoId...', name: 'YouTubeDatasource');
      final manifest = await _yt!.videos.streams.getManifest(videoId);
      dev.log('Got manifest with ${manifest.audioOnly.length} audio streams', name: 'YouTubeDatasource');

      // For iOS compatibility, prefer MP4A (AAC) streams with medium bitrate
      // High bitrate streams may have compatibility issues
      final compatibleStreams = manifest.audioOnly
          .where((s) =>
              s.codec.toString().contains('mp4a') &&
              s.bitrate.bitsPerSecond >= 128000 &&
              s.bitrate.bitsPerSecond <= 256000)
          .toList();

      // Sort by bitrate (prefer medium quality for compatibility)
      compatibleStreams.sort((a, b) => a.bitrate.compareTo(b.bitrate));

      dev.log(
        'Found ${manifest.audioOnly.length} total streams, ${compatibleStreams.length} compatible mp4a streams for $videoId',
        name: 'YouTubeDatasource',
      );

      if (compatibleStreams.isEmpty) {
        dev.log(
          'No compatible mp4a streams found, trying fallback to any mp4a stream',
          name: 'YouTubeDatasource',
        );
        // Fallback to any mp4a stream
        final anyMp4a = manifest.audioOnly
            .where((s) => s.codec.toString().contains('mp4a'))
            .toList();
        if (anyMp4a.isNotEmpty) {
          final selected = anyMp4a.first;
          dev.log(
            'Using fallback mp4a stream: ${selected.codec} @ ${selected.bitrate}bps',
            name: 'YouTubeDatasource',
          );
          return selected.url.toString();
        }

        dev.log('No mp4a streams found, using any audio stream', name: 'YouTubeDatasource');
        // Last resort: any audio stream
        final sortedStreams = manifest.audioOnly.toList()
          ..sort((a, b) => a.bitrate.compareTo(b.bitrate));
        if (sortedStreams.isEmpty) {
          dev.log('No audio streams available at all!', name: 'YouTubeDatasource');
          throw const YouTubeException("No audio available");
        }
        final selected = sortedStreams.first;
        dev.log(
          'Using last resort stream: ${selected.codec} @ ${selected.bitrate}bps',
          name: 'YouTubeDatasource',
        );
        return selected.url.toString();
      }

      final selected = compatibleStreams.first;
      dev.log(
        'Selected stream: ${selected.codec} @ ${selected.bitrate}bps, size: ${selected.size.totalBytes}',
        name: 'YouTubeDatasource',
      );

      return selected.url.toString();
    } on YouTubeException {
      rethrow;
    } catch (e) {
      dev.log(
        'Failed to extract audio URL for $videoId: $e',
        name: 'YouTubeDatasource',
        error: e,
      );
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
        name: 'YouTubeDatasource',
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
