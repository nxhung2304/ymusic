import 'package:flutter/material.dart';

class PodcastDetailScreen extends StatelessWidget {
  final String encodedFeedUrl;

  const PodcastDetailScreen({
    required this.encodedFeedUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Podcast')),
      body: Center(
        child: Text('Podcast Detail Screen\nEncoded Feed URL: $encodedFeedUrl'),
      ),
    );
  }
}
