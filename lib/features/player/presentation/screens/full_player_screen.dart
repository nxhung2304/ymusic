import 'package:flutter/material.dart';

class FullPlayerScreen extends StatelessWidget {
  final String? videoId;

  const FullPlayerScreen({
    this.videoId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Center(
        child: Text('Full Player Screen${videoId != null ? '\nVideo ID: $videoId' : ''}'),
      ),
    );
  }
}
