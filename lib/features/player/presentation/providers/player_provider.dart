import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/features/player/presentation/providers/player_notifier.dart';
import 'package:ymusic/features/player/presentation/providers/player_state.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

part 'player_provider.g.dart';

@riverpod
PlayerState playerState(Ref ref) {
  return ref.watch(playerNotifierProvider);
}

@riverpod
Song? currentSong(Ref ref) {
  return ref.watch(playerStateProvider).currentSong;
}

@riverpod
bool isPlaying(Ref ref) {
  return ref.watch(playerStateProvider).isPlaying;
}

@riverpod
Duration playerPosition(Ref ref) {
  return ref.watch(playerStateProvider).position;
}

@riverpod
Duration playerDuration(Ref ref) {
  return ref.watch(playerStateProvider).duration;
}

@riverpod
List<Song> playerQueue(Ref ref) {
  return ref.watch(playerStateProvider).queue;
}

@riverpod
double playerProgress(Ref ref) {
  return ref.watch(playerStateProvider).progress;
}
