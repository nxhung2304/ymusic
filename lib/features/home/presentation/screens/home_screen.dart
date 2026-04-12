import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_strings.dart';
import 'package:ymusic/features/player/presentation/providers/player_notifier.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';
import 'package:ymusic/features/search/presentation/widgets/song_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _hardcodedSongs = [
    Song(
      videoId: 'dQw4w9WgXcQ',
      title: 'Never Gonna Give You Up',
      artist: 'Rick Astley',
      thumbnailUrl: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg',
      duration: Duration(minutes: 3, seconds: 33),
    ),
    Song(
      videoId: 'kJQP7kiw5Fk',
      title: 'Despacito',
      artist: 'Luis Fonsi ft. Daddy Yankee',
      thumbnailUrl: 'https://i.ytimg.com/vi/kJQP7kiw5Fk/mqdefault.jpg',
      duration: Duration(minutes: 4, seconds: 42),
    ),
    Song(
      videoId: 'OPf0YbXqDm0',
      title: 'Uptown Funk ft. Bruno Mars',
      artist: 'Mark Ronson',
      thumbnailUrl: 'https://i.ytimg.com/vi/OPf0YbXqDm0/mqdefault.jpg',
      duration: Duration(minutes: 4, seconds: 0),
    ),
    Song(
      videoId: 'JGwWNGJdvx8',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      thumbnailUrl: 'https://i.ytimg.com/vi/JGwWNGJdvx8/mqdefault.jpg',
      duration: Duration(minutes: 3, seconds: 54),
    ),
    Song(
      videoId: 'RgKAFK5djSk',
      title: 'See You Again',
      artist: 'Wiz Khalifa',
      thumbnailUrl: 'https://i.ytimg.com/vi/RgKAFK5djSk/mqdefault.jpg',
      duration: Duration(minutes: 3, seconds: 58),
    ),
  ];

  void _onTapSong(WidgetRef ref, Song song) {
    final playerNotifier = ref.read(playerNotifierProvider.notifier);
    playerNotifier.setCurrentSong(song);
  }

  void _onTapMore(BuildContext context, Song song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('More: ${song.title}')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.title)),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _hardcodedSongs.length,
          itemBuilder: (_, index) {
            final song = _hardcodedSongs[index];

            return SongTile(
              song: song,
              onTap: () => _onTapSong(ref, song),
              onMoreTap: () => _onTapMore(context, song),
            );
          },
        ),
      ),
    );
  }
}
