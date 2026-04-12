import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

/// AudioHandler for background playback support using audio_service
class AudioHandler extends BaseAudioHandler {
  AudioHandler({required AudioPlayer player}) : _player = player {
    // Initialize the audio session
    _init();
  }

  final AudioPlayer _player;

  Future<void> _init() async {
    // Listen to playback state changes
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // Listen to media item changes (current playing song)
    _player.currentIndexStream.listen((index) {
      // Update media item when song changes
    });
  }

  /// Transform just_audio playback event to audio_service playback state
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState] ?? AudioProcessingState.idle,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: _player.currentIndex,
    );
  }

  @override
  Future<void> play() async {
    _player.play();
  }

  @override
  Future<void> pause() async {
    _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    // TODO: Implement queue navigation
  }

  @override
  Future<void> skipToPrevious() async {
    // TODO: Implement queue navigation
  }

  /// Play a specific song
  Future<void> playSong(Song song, String url) async {
    final mediaItem = MediaItem(
      id: song.videoId,
      title: song.title,
      artist: song.artist,
      artUri: Uri.parse(song.thumbnailUrl),
      duration: song.duration,
    );

    // Set the media item for notification/lock screen controls
    // Note: In a full implementation, you would use audio_service's queue system
    // For now, we just set the current media item directly on the player

    // Load and play the audio
    final dataSource = LockCachingAudioSource(
      Uri.parse(url),
      tag: mediaItem,
      headers: {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Referer': 'https://www.youtube.com/',
        'Origin': 'https://www.youtube.com',
      },
    );

    await _player.setAudioSource(dataSource, preload: true);
    await _player.play();
  }
}
