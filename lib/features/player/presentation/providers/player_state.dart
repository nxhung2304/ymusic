import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

part 'player_state.freezed.dart';

@freezed
abstract class PlayerState with _$PlayerState {
  const PlayerState._();

  const factory PlayerState({
    required Song? currentSong, // null nếu chưa phát gì
    required bool isPlaying, // true/false
    required Duration position, // vị trí hiện tại
    required Duration duration, // độ dài bài
    required List<Song> queue, // danh sách bài tới
    required int queueIndex, // index bài hiện tại trong queue
  }) = _PlayerState;

  // Convenience getters
  bool get hasNext => queueIndex < queue.length - 1;
  bool get hasPrev => queueIndex > 0;
  Song? get nextSong => hasNext ? queue[queueIndex + 1] : null;
  double get progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }
}
