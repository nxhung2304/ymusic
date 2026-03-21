import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/services/youtube_service.dart';
import 'package:ymusic/core/utils/request_queue.dart';

// ─── Fixtures ─────────────────────────────────────────────────────────────────

const _videoId = 'dQw4w9WgXcQ';
const _title = 'Test Song';
const _artist = 'Test Artist';
const _query = 'test query';
const _duration = Duration(minutes: 3, seconds: 45);
const _audioUrl = 'https://audio.url/stream';
const _fallbackUrl = 'https://audio.url/fallback';

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

// ─── Search fakes ─────────────────────────────────────────────────────────────

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

// ─── Streams fakes ────────────────────────────────────────────────────────────

class _FakeStreamsClient implements YouTubeStreamsClient {
  _FakeStreamsClient(this._urls);

  final List<Uri> _urls;

  @override
  Future<List<Uri>> getSortedAudioUrls(String videoId) async => _urls;
}

class _ThrowingStreamsClient implements YouTubeStreamsClient {
  @override
  Future<List<Uri>> getSortedAudioUrls(String videoId) =>
      Future.error(Exception('Stream network error'));
}

class _VideoIdAwareStreamsClient implements YouTubeStreamsClient {
  @override
  Future<List<Uri>> getSortedAudioUrls(String videoId) async =>
      [Uri.parse('https://audio.url/$videoId')];
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

  group('YouTubeService.extractAudioUrl', () {
    test('returns URL from highest-quality stream', () async {
      final service = YouTubeService.withClient(
        _FakeClient([]),
        streamsClient: _FakeStreamsClient([Uri.parse(_audioUrl)]),
        queue: RequestQueue(delay: Duration.zero),
      );

      final url = await service.extractAudioUrl(_videoId);

      expect(url, _audioUrl);
    });

    test('falls back to next stream when first URL is empty', () async {
      final service = YouTubeService.withClient(
        _FakeClient([]),
        streamsClient: _FakeStreamsClient([
          Uri.parse(''),
          Uri.parse(_fallbackUrl),
        ]),
        queue: RequestQueue(delay: Duration.zero),
      );

      final url = await service.extractAudioUrl(_videoId);

      expect(url, _fallbackUrl);
    });

    test('throws YouTubeException when all stream URLs are empty', () async {
      final service = YouTubeService.withClient(
        _FakeClient([]),
        streamsClient: _FakeStreamsClient([Uri.parse(''), Uri.parse('')]),
        queue: RequestQueue(delay: Duration.zero),
      );

      await expectLater(
        service.extractAudioUrl(_videoId),
        throwsA(isA<YouTubeException>()),
      );
    });

    test('throws YouTubeException when stream client throws', () async {
      final service = YouTubeService.withClient(
        _FakeClient([]),
        streamsClient: _ThrowingStreamsClient(),
        queue: RequestQueue(delay: Duration.zero),
      );

      await expectLater(
        service.extractAudioUrl(_videoId),
        throwsA(isA<YouTubeException>()),
      );
    });

    test('throttles concurrent requests — completes in >= 2x delay', () async {
      // Uses 200ms delay instead of 1s to keep test fast while proving throttle.
      // 3 requests with 1 delay between each pair = minimum 2 × 200ms = 400ms.
      const throttleDelay = Duration(milliseconds: 200);
      final service = YouTubeService.withClient(
        _FakeClient([]),
        streamsClient: _FakeStreamsClient([Uri.parse(_audioUrl)]),
        queue: RequestQueue(delay: throttleDelay),
      );

      final stopwatch = Stopwatch()..start();
      await Future.wait([
        service.extractAudioUrl('id1'),
        service.extractAudioUrl('id2'),
        service.extractAudioUrl('id3'),
      ]);
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(400));
    });

    test('concurrent requests return correct URL per videoId', () async {
      final service = YouTubeService.withClient(
        _FakeClient([]),
        streamsClient: _VideoIdAwareStreamsClient(),
        queue: RequestQueue(delay: Duration.zero),
      );

      final results = await Future.wait([
        service.extractAudioUrl('id1'),
        service.extractAudioUrl('id2'),
        service.extractAudioUrl('id3'),
      ]);

      expect(results[0], 'https://audio.url/id1');
      expect(results[1], 'https://audio.url/id2');
      expect(results[2], 'https://audio.url/id3');
    });
  });
}
