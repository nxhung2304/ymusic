import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/services/audio_player_service.dart';
import 'package:ymusic/core/utils/app_logger.dart';
import 'package:ymusic/features/player/presentation/providers/player_state.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

part 'player_notifier.g.dart';

@riverpod
class PlayerNotifier extends _$PlayerNotifier {
  Timer? _positionPollTimer;

  @override
  PlayerState build() {
    _setupStreamListeners();

    ref.onDispose(() {
      _positionPollTimer?.cancel();
    });

    return const PlayerState(
      currentSong: null,
      isPlaying: false,
      position: Duration.zero,
      duration: Duration.zero,
      queue: [],
      queueIndex: -1,
    );
  }

  void _setupStreamListeners() {
    final audioService = ref.read(audioPlayerServiceProvider);

    final playerStateSub = audioService.playerStateStream.listen((playerState) {
      AppLogger.d('PlayerState stream: playing=${playerState.playing}, processingState=${playerState.processingState}');
      final wasPlaying = state.isPlaying;
      state = state.copyWith(isPlaying: playerState.playing);

      // Start/stop position polling based on playing state
      if (playerState.playing && !wasPlaying) {
        _startPositionPolling();
      } else if (!playerState.playing && wasPlaying) {
        _stopPositionPolling();
      }
    });

    final positionSub = audioService.positionStream.listen((position) {
      AppLogger.d('Position stream: ${position.inSeconds}s');
      state = state.copyWith(position: position);
    });

    // Note: We don't listen to durationStream because YouTube audio streams
    // don't provide reliable duration. We use duration from Song metadata instead.

    ref.onDispose(() {
      playerStateSub.cancel();
      positionSub.cancel();
      _stopPositionPolling();
    });
  }

  void _startPositionPolling() {
    _positionPollTimer?.cancel();
    _positionPollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final audioService = ref.read(audioPlayerServiceProvider);
      final position = audioService.currentPosition;
      AppLogger.d('Position poll: ${position.inSeconds}s');
      state = state.copyWith(position: position);
    });
  }

  void _stopPositionPolling() {
    _positionPollTimer?.cancel();
    _positionPollTimer = null;
  }

  void setCurrentSong(Song song) async {
    // Check if same song is already playing
    final isSameSong = state.currentSong?.videoId == song.videoId;

    AppLogger.d('setCurrentSong: ${song.title} (${song.videoId}), isSameSong: $isSameSong, currentSong: ${state.currentSong?.title}');

    final index = state.queue.indexOf(song);
    state = state.copyWith(
      currentSong: song,
      isPlaying: true,
      position: Duration.zero,
      duration: song.duration, // Use duration from song metadata
      queueIndex: index != -1 ? index : 0,
    );

    final audioService = ref.read(audioPlayerServiceProvider);

    // Only play if it's a different song
    if (!isSameSong) {
      AppLogger.d('setCurrentSong: Calling audioService.play()');
      try {
        await audioService.play(song);
      } catch (e) {
        // If play fails, update state to reflect error
        state = state.copyWith(isPlaying: false);
        // Optionally show error to user
        AppLogger.d('Error playing song: $e');
      }
    } else if (!state.isPlaying) {
      // Same song but paused, just resume
      AppLogger.d('setCurrentSong: Same song, calling resume()');
      audioService.resume();
    } else {
      AppLogger.d('setCurrentSong: Same song and already playing, doing nothing');
    }
  }

  void addToQueue(Song song) {
    AppLogger.d('Adding to queue: ${song.title} (${song.videoId})');
    final updatedQueue = [...state.queue, song];
    state = state.copyWith(queue: updatedQueue);
  }

  void clearQueue() {
    AppLogger.d('Clearing queue');
    state = state.copyWith(queue: [], queueIndex: -1);
  }

  void clearCurrentSong() {
    AppLogger.d('Clearing current song');
    state = state.copyWith(currentSong: null);
  }

  void updatePosition(Duration position) {
    AppLogger.d('Updating position to ${position.inSeconds}s');
    state = state.copyWith(position: position);
  }

  void togglePlayback() {
    AppLogger.d('Toggle playback: isPlaying=${state.isPlaying}');
    final audioService = ref.read(audioPlayerServiceProvider);
    if (state.isPlaying) {
      audioService.pause();
    } else {
      audioService.resume();
    }
  }

  void previous() {
    if (!state.hasPrev) {
      AppLogger.d('Previous: No previous song');
      return;
    }

    final newIndex = state.queueIndex - 1;
    final newSong = state.queue[newIndex];

    AppLogger.d('Previous: Playing ${newSong.title} at index $newIndex');

    state = state.copyWith(
      currentSong: newSong,
      queueIndex: newIndex,
      position: Duration.zero,
      duration: newSong.duration, // Use duration from song metadata
    );

    final audioService = ref.read(audioPlayerServiceProvider);
    audioService.play(newSong);
  }

  void next() {
    if (!state.hasNext) {
      AppLogger.d('Next: No next song');
      return;
    }

    final newIndex = state.queueIndex + 1;
    final newSong = state.queue[newIndex];

    AppLogger.d('Next: Playing ${newSong.title} at index $newIndex');

    state = state.copyWith(
      currentSong: newSong,
      queueIndex: newIndex,
      position: Duration.zero,
      duration: newSong.duration, // Use duration from song metadata
    );

    final audioService = ref.read(audioPlayerServiceProvider);
    audioService.play(newSong);
  }

  void seekToPosition(double progress) async {
    // Validate: only seek if we have a valid duration
    if (state.duration.inMilliseconds <= 0) {
      AppLogger.d('Cannot seek: invalid duration');
      return;
    }

    final totalMs = state.duration.inMilliseconds;
    final seekMs = (totalMs * progress).round();
    final seekPosition = Duration(milliseconds: seekMs);

    // Optimistically update position for immediate UI feedback
    state = state.copyWith(position: seekPosition);

    try {
      final audioService = ref.read(audioPlayerServiceProvider);
      await audioService.seek(seekPosition);
    } catch (e) {
      AppLogger.d('Error seeking: $e');
      // Revert to current position on error
      state = state.copyWith(position: state.position);
    }
  }
}
