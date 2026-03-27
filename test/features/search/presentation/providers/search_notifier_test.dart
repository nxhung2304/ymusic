import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/datasources/youtube_datasource.dart';
import 'package:ymusic/core/providers/app_providers.dart';
import 'package:ymusic/features/search/data/models/song_model.dart';
import 'package:ymusic/features/search/presentation/providers/search_notifier.dart';
import 'package:ymusic/features/search/presentation/providers/search_state.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// ─── Fixtures ─────────────────────────────────────────────────────────────────

const _query = 'shape of you';
const _videoId = 'dQw4w9WgXcQ';
const _title = 'Shape of You';
const _artist = 'Ed Sheeran';
const _thumbnailUrl = 'https://example.com/thumb.jpg';
const _duration = Duration(minutes: 3, seconds: 53);

final _fakeSong = const SongModel(
  videoId: _videoId,
  title: _title,
  artist: _artist,
  thumbnailUrl: _thumbnailUrl,
  duration: _duration,
);

// ─── Fake ─────────────────────────────────────────────────────────────────────

class _FakeYouTubeDatasource extends YouTubeDatasource {
  _FakeYouTubeDatasource() : super(YoutubeExplode());

  late Future<List<SongModel>> Function(String) _onSearch;

  void stubSearch(Future<List<SongModel>> Function(String) handler) {
    _onSearch = handler;
  }

  @override
  Future<List<SongModel>> search(String query) => _onSearch(query);
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

ProviderContainer _makeContainer(_FakeYouTubeDatasource fakeService) {
  return ProviderContainer(
    overrides: [
      youTubeDatasourceProvider.overrideWithValue(fakeService),
    ],
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late _FakeYouTubeDatasource fakeService;
  late ProviderContainer container;

  setUp(() {
    fakeService = _FakeYouTubeDatasource();
    container = _makeContainer(fakeService);
  });

  tearDown(() {
    container.dispose();
  });

  group('SearchNotifier.build', () {
    test('returns initial state on creation', () {
      expect(
        container.read(searchNotifierProvider),
        const SearchState.initial(),
      );
    });
  });

  group('SearchNotifier.clear', () {
    test('resets state to initial', () {
      fakeService.stubSearch((_) async => [_fakeSong]);

      container.read(searchNotifierProvider.notifier).clear();

      expect(
        container.read(searchNotifierProvider),
        const SearchState.initial(),
      );
    });
  });

  group('SearchNotifier.search', () {
    test('emits results state when songs are found', () async {
      fakeService.stubSearch((_) async => [_fakeSong]);

      await container.read(searchNotifierProvider.notifier).search(_query);

      final songs = container.read(searchNotifierProvider).whenOrNull(
        results: (items) => items,
      );
      expect(songs, hasLength(1));
    });

    test('emits empty state when no songs are found', () async {
      fakeService.stubSearch((_) async => []);

      await container.read(searchNotifierProvider.notifier).search(_query);

      final emptyQuery = container.read(searchNotifierProvider).whenOrNull(
        empty: (query) => query,
      );
      expect(emptyQuery, _query);
    });

    test('emits error state when YouTubeException is thrown', () async {
      fakeService.stubSearch(
        (_) => Future.error(const YouTubeException('Network error')),
      );

      await container.read(searchNotifierProvider.notifier).search(_query);

      final errorMsg = container.read(searchNotifierProvider).whenOrNull(
        error: (message) => message,
      );
      expect(errorMsg, contains('Network error'));
    });

    test('clears and returns initial state when query is empty', () async {
      fakeService.stubSearch((_) async => [_fakeSong]);

      await container.read(searchNotifierProvider.notifier).search(_query);
      await container.read(searchNotifierProvider.notifier).search('');

      expect(
        container.read(searchNotifierProvider),
        const SearchState.initial(),
      );
    });

    test('clears and returns initial state when query is whitespace', () async {
      fakeService.stubSearch((_) async => [_fakeSong]);

      await container.read(searchNotifierProvider.notifier).search('   ');

      expect(
        container.read(searchNotifierProvider),
        const SearchState.initial(),
      );
    });
  });

  group('SearchNotifier.onQueryChanged', () {
    test('emits loading immediately before debounce fires', () async {
      fakeService.stubSearch((_) async => [_fakeSong]);

      container.read(searchNotifierProvider.notifier).onQueryChanged(_query);

      expect(
        container.read(searchNotifierProvider),
        const SearchState.loading(),
      );
    });

    test('emits initial state when query becomes empty', () async {
      fakeService.stubSearch((_) async => [_fakeSong]);

      container.read(searchNotifierProvider.notifier).onQueryChanged('');

      expect(
        container.read(searchNotifierProvider),
        const SearchState.initial(),
      );
    });

    test('emits suggestions state after debounce completes', () async {
      fakeService.stubSearch((_) async => [_fakeSong]);

      // Keep provider alive (AutoDispose disposes when no listeners)
      final sub = container.listen(searchNotifierProvider, (_, __) {});

      container.read(searchNotifierProvider.notifier).onQueryChanged(_query);

      // Wait for debounce (500ms) + time for async _fetchSongs to complete
      const debounceWait = Duration(milliseconds: 700);
      await Future<void>.delayed(debounceWait);

      final songs = container.read(searchNotifierProvider).whenOrNull(
        suggestions: (items) => items,
      );
      sub.close();

      expect(songs, isNotNull);
    });
  });
}
