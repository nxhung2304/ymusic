import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/services/youtube_service.dart';

// ─── Fixtures ─────────────────────────────────────────────────────────────────

const _videoId = 'dQw4w9WgXcQ';
const _title = 'Test Song';
const _artist = 'Test Artist';
const _query = 'test query';
const _duration = Duration(minutes: 3, seconds: 45);

Video _makeVideo({
  String id = _videoId,
  String title = _title,
  String author = _artist,
  Duration? duration = _duration,
}) {
  return Video(
    VideoId(id),
    title,
    author,
    ChannelId('UCuAXFkgsw1L7xaCfnd5JJOw'),
    null,
    null,
    null,
    '',
    duration,
    ThumbnailSet(id),
    null,
    const Engagement(0, null, null),
    false,
  );
}

// ─── Fakes ────────────────────────────────────────────────────────────────────

class _FakeClient implements YouTubeSearchClient {
  _FakeClient(this._videos);

  final List<Video> _videos;

  @override
  Future<List<Video>> searchVideos(String query) async => _videos;
}

class _ThrowingClient implements YouTubeSearchClient {
  @override
  Future<List<Video>> searchVideos(String query) =>
      Future.error(Exception('Network error'));
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('YouTubeService.search', () {
    test('returns parsed SongModels when results are found', () async {
      final video = _makeVideo();
      final service = YouTubeService.withClient(_FakeClient([video]));

      final result = await service.search(_query);

      expect(result, hasLength(1));
      expect(result.first.videoId, _videoId);
      expect(result.first.title, _title);
      expect(result.first.artist, _artist);
      expect(result.first.thumbnailUrl, contains(_videoId));
      expect(result.first.duration, _duration);
    });

    test('returns empty list when no results', () async {
      final service = YouTubeService.withClient(_FakeClient([]));

      final result = await service.search(_query);

      expect(result, isEmpty);
    });

    test('sets duration to Duration.zero when video duration is null', () async {
      final video = _makeVideo(duration: null);
      final service = YouTubeService.withClient(_FakeClient([video]));

      final result = await service.search(_query);

      expect(result.first.duration, Duration.zero);
    });

    test('throws YouTubeException on network error', () async {
      final service = YouTubeService.withClient(_ThrowingClient());

      await expectLater(
        service.search(_query),
        throwsA(isA<YouTubeException>()),
      );
    });
  });
}
