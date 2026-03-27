import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.suggestions(List<Song> items) = _Suggestions;
  const factory SearchState.results(List<Song> items) = _Results;
  const factory SearchState.empty(String query) = _Empty;
  const factory SearchState.error(String message) = _Error;
}
