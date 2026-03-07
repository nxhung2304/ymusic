import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API endpoints and other constants
/// Environment variables are loaded from .env file via flutter_dotenv
class AppConstants {
  // API Base URLs
  static const String youtubeApiBaseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String lrclibApiBaseUrl = 'https://lrclib.net/api';

  // Environment-based configuration (loaded from .env)
  static String get youtubeApiKey {
    final key = dotenv.env['YOUTUBE_API_KEY'];
    if (key == null || key.isEmpty || key == 'REPLACE_WITH_YOUR_YOUTUBE_API_KEY') {
      throw Exception('YouTube API key not configured. Set YOUTUBE_API_KEY in .env file');
    }
    return key;
  }

  static String get firebaseProjectId {
    return dotenv.env['FIREBASE_PROJECT_ID'] ?? 'ymusic-dev';
  }

  static String get googleOAuthClientId {
    final clientId = dotenv.env['GOOGLE_OAUTH_CLIENT_ID'];
    if (clientId == null || clientId.isEmpty || clientId == 'REPLACE_WITH_YOUR_OAUTH_CLIENT_ID') {
      throw Exception('Google OAuth Client ID not configured. Set GOOGLE_OAUTH_CLIENT_ID in .env file');
    }
    return clientId;
  }

  static String get appEnv {
    return dotenv.env['APP_ENV'] ?? 'development';
  }

  static String get logLevel {
    return dotenv.env['LOG_LEVEL'] ?? 'info';
  }

  static bool get enableAnalytics {
    return dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  }

  static bool get enableCrashReporting {
    return dotenv.env['ENABLE_CRASH_REPORTING']?.toLowerCase() == 'true';
  }

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
