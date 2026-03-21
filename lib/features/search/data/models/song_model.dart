import 'package:ymusic/features/search/domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.videoId,
    required super.title,
    required super.artist,
    required super.thumbnailUrl,
    required super.duration,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      duration: Duration(seconds: json['durationSeconds'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'artist': artist,
      'thumbnailUrl': thumbnailUrl,
      'durationSeconds': duration.inSeconds,
    };
  }
}
