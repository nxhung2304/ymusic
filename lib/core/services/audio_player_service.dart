import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/datasources/youtube_datasource.dart';
import 'package:ymusic/core/providers/app_providers.dart';
import 'package:ymusic/features/search/data/models/song_model.dart';

part 'audio_player_service.g.dart';

abstract class AudioPlayerService {
  Stream<PlayerState> get playerStateStream;
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<bool> get playingStream;

  Future<void> play(SongModel song);
  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration position);
  Future<void> next();
  Future<void> prev();
  Future<void> stop();
  void dispose();
}

class JustAudioPlayerService implements AudioPlayerService {
  JustAudioPlayerService({
    required AudioPlayer player,
    required YouTubeDatasource youtubeDatasource,
  })  : _player = player,
        _youtubeDatasource = youtubeDatasource;

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
  Future<void> play(SongModel song) async {
    final url = await _youtubeDatasource.extractAudioUrl(song.videoId);
    await _player.setUrl(url);
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> resume() => _player.play();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

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
    _player.dispose();
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
