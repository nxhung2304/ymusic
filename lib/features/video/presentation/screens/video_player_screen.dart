import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;

  const VideoPlayerScreen({
    required this.videoId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video')),
      body: Center(
        child: Text('Video Player Screen\nVideo ID: $videoId'),
      ),
    );
  }
}
