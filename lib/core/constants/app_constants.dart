/// API endpoints and other constants
class AppConstants {
  // API Base URLs
  static const String youtubeApiBaseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String lrclibApiBaseUrl = 'https://lrclib.net/api';

  // TODO: Add your YouTube API key here (get from Google Cloud Console)
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY_HERE';

  // Firebase configuration - handled by google-services.json and GoogleService-Info.plist
  static const String firebaseProjectId = 'ymusic-project';

  // App constants
  static const int defaultTimeoutSeconds = 30;
  static const int searchDebounceMs = 500;
  static const int maxRetries = 3;

  // Cache constants
  static const Duration searchCacheDuration = Duration(hours: 24);
  static const Duration lyricsCacheDuration = Duration(days: 7);

  // UI constants
  static const double minPlayerHeight = 56.0;
  static const double maxPlayerHeight = 500.0;
}
