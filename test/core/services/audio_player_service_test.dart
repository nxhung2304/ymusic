import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ymusic/core/data/models/song_model.dart';
import 'package:ymusic/core/data/datasources/youtube_datasource.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/services/audio_player_service.dart';

// ─── Fixtures ──────────────────────────────────────────────────────────────────

const _videoId = 'dQw4w9WgXcQ';
const _audioUrl = 'https://example.com/audio.mp3';
const _seekPosition = Duration(seconds: 30);

const _song = SongModel(
  videoId: _videoId,
  title: 'Test Song',
  artist: 'Test Artist',
  thumbnailUrl: 'https://example.com/thumb.jpg',
  duration: Duration(minutes: 3),
);

// ─── Mocks ─────────────────────────────────────────────────────────────────────

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockYouTubeDatasource extends Mock implements YouTubeDatasource {}

// ─── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late MockAudioPlayer mockPlayer;
  late MockYouTubeDatasource mockDatasource;
  late JustAudioPlayerService service;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockPlayer = MockAudioPlayer();
    mockDatasource = MockYouTubeDatasource();
    service = JustAudioPlayerService(
      player: mockPlayer,
      youtubeDatasource: mockDatasource,
    );
  });

  group('play', () {
    test('calls extractAudioUrl with videoId, setUrl and play on happy path', () async {
      when(() => mockDatasource.extractAudioUrl(_videoId))
          .thenAnswer((_) async => _audioUrl);
      when(() => mockPlayer.setUrl(_audioUrl)).thenAnswer((_) async => null);
      when(() => mockPlayer.play()).thenAnswer((_) async {});

      await service.play(_song);

      verify(() => mockDatasource.extractAudioUrl(_videoId)).called(1);
      verify(() => mockPlayer.setUrl(_audioUrl)).called(1);
      verify(() => mockPlayer.play()).called(1);
    });

    test('rethrows YouTubeException when extractAudioUrl throws', () async {
      when(() => mockDatasource.extractAudioUrl(any()))
          .thenThrow(const YouTubeException('Extraction failed'));

      await expectLater(
        service.play(_song),
        throwsA(isA<YouTubeException>()),
      );

      verifyNever(() => mockPlayer.setUrl(any()));
    });
  });

  group('pause', () {
    test('calls player.pause()', () async {
      when(() => mockPlayer.pause()).thenAnswer((_) async {});

      await service.pause();

      verify(() => mockPlayer.pause()).called(1);
    });
  });

  group('resume', () {
    test('calls player.play()', () async {
      when(() => mockPlayer.play()).thenAnswer((_) async {});

      await service.resume();

      verify(() => mockPlayer.play()).called(1);
    });
  });

  group('seek', () {
    test('calls player.seek with given position', () async {
      when(() => mockPlayer.seek(any())).thenAnswer((_) async {});

      await service.seek(_seekPosition);

      verify(() => mockPlayer.seek(_seekPosition)).called(1);
    });
  });

  group('next', () {
    test('is a no-op and does not call any player methods', () async {
      await service.next();

      verifyNever(() => mockPlayer.play());
      verifyNever(() => mockPlayer.pause());
      verifyNever(() => mockPlayer.seek(any()));
    });
  });

  group('prev', () {
    test('is a no-op and does not call any player methods', () async {
      await service.prev();

      verifyNever(() => mockPlayer.play());
      verifyNever(() => mockPlayer.pause());
      verifyNever(() => mockPlayer.seek(any()));
    });
  });

  group('stop', () {
    test('calls player.stop()', () async {
      when(() => mockPlayer.stop()).thenAnswer((_) async {});

      await service.stop();

      verify(() => mockPlayer.stop()).called(1);
    });
  });

  group('dispose', () {
    test('calls player.dispose()', () {
      when(() => mockPlayer.dispose()).thenAnswer((_) async {});

      service.dispose();

      verify(() => mockPlayer.dispose()).called(1);
    });
  });

  group('playerStateStream', () {
    test('forwards stream from player', () {
      final stream = const Stream<PlayerState>.empty();
      when(() => mockPlayer.playerStateStream).thenAnswer((_) => stream);

      expect(service.playerStateStream, equals(stream));
    });
  });

  group('positionStream', () {
    test('forwards stream from player', () {
      final stream = const Stream<Duration>.empty();
      when(() => mockPlayer.positionStream).thenAnswer((_) => stream);

      expect(service.positionStream, equals(stream));
    });
  });
}
