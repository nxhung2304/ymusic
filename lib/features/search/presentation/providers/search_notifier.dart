import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/features/search/presentation/providers/search_provider.dart';
import 'package:ymusic/features/search/presentation/providers/search_state.dart';

part 'search_notifier.g.dart';

enum SearchType { search, suggestions }

const _kSearchDebounceDuration = Duration(milliseconds: 500);

@riverpod
class SearchNotifier extends _$SearchNotifier {
  Timer? _debounceSearch;

  @override
  SearchState build() {
    ref.onDispose(() => _debounceSearch?.cancel());

    return const SearchState.initial();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      clear();

      return;
    }

    _debounceSearch?.cancel();

    await _fetchSongs(query, SearchType.search);
  }

  Future<void> onQueryChanged(String query) async {
    if (query.trim().isEmpty) {
      clear();

      return;
    }

    _debounceSearch?.cancel();

    state = const SearchState.loading();

    _debounceSearch = Timer(
      _kSearchDebounceDuration,
      () => _fetchSongs(query, SearchType.suggestions),
    );
  }

  void clear() {
    state = const SearchState.initial();
  }

  Future<void> _fetchSongs(String query, SearchType searchType) async {
    state = const SearchState.loading();

    final result = await ref.read(searchRepositoryProvider).search(query);

    result.fold((failure) => state = SearchState.error(failure.message), (
      songs,
    ) {
      if (songs.isEmpty) {
        state = SearchState.empty(query);
        return;
      }
      state = switch (searchType) {
        SearchType.search => SearchState.results(songs),
        SearchType.suggestions => SearchState.suggestions(songs),
      };
    });
  }
}
