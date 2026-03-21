class Song {
  final String videoId;
  final String title;
  final String artist;
  final String thumbnailUrl;
  final Duration duration;

  const Song({
    required this.videoId,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    required this.duration,
  });
}
