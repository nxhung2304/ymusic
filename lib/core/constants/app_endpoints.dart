class AppEndpoints {
  AppEndpoints._();

  static const String _youtubeBase = 'https://www.googleapis.com/youtube/v3';

  static const String youtubeSearch = '$_youtubeBase/search';
  static const String youtubeVideos = '$_youtubeBase/videos';

  static const String lrclibBase = 'https://lrclib.net/api';
  static const String lrclibSearch = '$lrclibBase/search';
  static const String lrclibGet = '$lrclibBase/get';
}
