import 'package:flutter/material.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

class SuggestionDropdown extends StatelessWidget {
  static const int _kMaxSuggestions = 5;

  const SuggestionDropdown({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  final List<Song> suggestions;
  final void Function(Song) onSelect;

  int get _suggestionCount => suggestions.length.clamp(0, _kMaxSuggestions);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _suggestionCount,
      itemBuilder: (context, index) {
        final song = suggestions[index];

        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(song.title),
          onTap: () => onSelect(song),
        );
      },
    );
  }
}
