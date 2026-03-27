import 'package:flutter/material.dart';
import 'package:ymusic/core/constants/app_strings.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';
import 'package:ymusic/features/search/presentation/widgets/song_tile.dart';

class SongList extends StatelessWidget {

  const SongList({super.key, required this.songs});

  final List<Song> songs;

  void _onTapSong(BuildContext context, Song song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.playing(song.title))),
    );
  }

  void _onTapMore(BuildContext context, Song song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.more(song.title))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (_, index) {
        final song = songs[index];

        return SongTile(
          song: song,
          onTap: () => _onTapSong(context, song),
          onMoreTap: () => _onTapMore(context, song),
        );
      },
    );
  }
}
