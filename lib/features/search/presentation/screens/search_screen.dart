import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_strings.dart';
import 'package:ymusic/core/widgets/app_loading.dart';
import 'package:ymusic/core/widgets/main_appbar.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';
import 'package:ymusic/features/search/presentation/providers/search_notifier.dart';
import 'package:ymusic/features/search/presentation/providers/search_state.dart';
import 'package:ymusic/features/search/presentation/widgets/song_list.dart';
import 'package:ymusic/features/search/presentation/widgets/suggestion_dropdown.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSelectSuggestion(Song song) {
    _searchController.text = song.title;
    ref.read(searchNotifierProvider.notifier).search(song.title);
    FocusScope.of(context).unfocus();
  }

  void _onClearButtonClicked() {
    ref.read(searchNotifierProvider.notifier).clear();
    _searchController.clear();
  }

  void _onQueryChanged(String query) {
    ref.read(searchNotifierProvider.notifier).onQueryChanged(query);
  }

  void _onSubmitted(String query) {
    ref.read(searchNotifierProvider.notifier).search(query);
  }

  void _onRetry() {
    ref.read(searchNotifierProvider.notifier).search(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      appBar: const MainAppbar(title: AppStrings.navSearch),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SearchBar(
              controller: _searchController,
              hintText: AppStrings.searchHint,
              onChanged: _onQueryChanged,
              onSubmitted: _onSubmitted,
              trailing: <Widget>[
                ValueListenableBuilder(
                  valueListenable: _searchController,
                  builder:
                      (_, value, __) =>
                          value.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _onClearButtonClicked,
                              )
                              : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchState.when(
              initial: () => const SizedBox(),
              loading: () => const AppLoading(),
              suggestions:
                  (songs) => SuggestionDropdown(
                    suggestions: songs,
                    onSelect: _onSelectSuggestion,
                  ),
              results: (songs) => SongList(songs: songs),
              empty:
                  (query) =>
                      Center(child: Text(AppStrings.searchNoResults(query))),
              error:
                  (message) => _ErrorView(message: message, onRetry: _onRetry),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: const Text(AppStrings.searchRetry),
          ),
        ],
      ),
    );
  }
}
