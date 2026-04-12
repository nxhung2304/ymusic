import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/data/datasources/youtube_datasource.dart';
import 'package:ymusic/core/providers/app_providers.dart';
import 'package:ymusic/core/utils/app_logger.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

part 'audio_player_service.g.dart';

abstract class AudioPlayerService {
  Stream<PlayerState> get playerStateStream;
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<bool> get playingStream;
  Duration get currentPosition;

  Future<void> play(Song song);
  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration position);
  Future<void> next();
  Future<void> prev();
  Future<void> stop();
  void dispose();
}

class JustAudioPlayerService with WidgetsBindingObserver implements AudioPlayerService {
  JustAudioPlayerService({
    required AudioPlayer player,
    required YouTubeDatasource youtubeDatasource,
  })  : _player = player,
        _youtubeDatasource = youtubeDatasource {
    WidgetsBinding.instance.addObserver(this);
  }

  final AudioPlayer _player;
  final YouTubeDatasource _youtubeDatasource;

  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Stream<bool> get playingStream => _player.playingStream;

  @override
  Duration get currentPosition => _player.position;

  @override
  Future<void> play(Song song) async {
    try {
      AppLogger.d('AudioPlayerService: Attempting to play ${song.title} (${song.videoId})');
      final url = await _youtubeDatasource.extractAudioUrl(song.videoId);
      AppLogger.d('AudioPlayerService: Got URL: ${url.length > 100 ? url.substring(0, 100) : url}...');

      // Use LockCachingAudioSource for better YouTube stream handling
      // This caches the stream locally and allows for better playback
      final dataSource = LockCachingAudioSource(
        Uri.parse(url),
        tag: MediaItem(
          id: song.videoId,
          title: song.title,
          artist: song.artist,
          artUri: Uri.parse(song.thumbnailUrl),
          duration: song.duration,
        ),
        headers: {
          // Browser-like headers to avoid YouTube blocking
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
          'Accept': '*/*',
          'Accept-Language': 'en-US,en;q=0.9',
          'Referer': 'https://www.youtube.com/',
          'Origin': 'https://www.youtube.com',
        },
      );

      await _player.setAudioSource(dataSource,
          // Preload the audio to avoid buffering issues
          preload: true);

      AppLogger.d('AudioPlayerService: Audio source set, calling play()');
      await _player.play();
      AppLogger.d('AudioPlayerService: play() called successfully');
    } catch (e) {
      // If URL extraction or loading fails, clean up and rethrow
      AppLogger.d('AudioPlayerService: Error - $e');
      await _player.stop();
      rethrow;
    }
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> resume() => _player.play();

  @override
  Future<void> seek(Duration position) async {
    try {
      // Only seek if player has a valid duration and is in playable state
      final duration = _player.duration;
      if (duration == null || duration.inMilliseconds <= 0) {
        return;
      }

      // Clamp position to valid range
      final clampedPosition = position.compareTo(Duration.zero) < 0
          ? Duration.zero
          : position.compareTo(duration) > 0
              ? duration
              : position;

      await _player.seek(clampedPosition);
    } catch (e) {
      // Silently fail on seek errors - just_audio may have issues with some streams
      AppLogger.d('Seek error: $e');
    }
  }

  @override
  Future<void> next() async {
    // TODO(3.8): Wire to queueProvider
  }

  @override
  Future<void> prev() async {
    // TODO(3.8): Wire to queueProvider
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is going to background
      AppLogger.d('AudioPlayerService: App going to background');
    } else if (state == AppLifecycleState.resumed) {
      // App is coming to foreground
      AppLogger.d('AudioPlayerService: App resumed');
    }
  }
}

@Riverpod(keepAlive: true)
AudioPlayerService audioPlayerService(Ref ref) {
  final youtubeDatasource = ref.watch(youTubeDatasourceProvider);
  final service = JustAudioPlayerService(
    player: AudioPlayer(),
    youtubeDatasource: youtubeDatasource,
  );
  ref.onDispose(service.dispose);

  return service;
}
