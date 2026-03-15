import 'package:flutter/material.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailScreen({
    required this.playlistId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist')),
      body: Center(
        child: Text('Playlist Detail Screen\nPlaylist ID: $playlistId'),
      ),
    );
  }
}
