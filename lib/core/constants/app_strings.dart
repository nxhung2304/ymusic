class AppStrings {
  AppStrings._();

  static const String title = "YMusic";

  // Navigation
  static const String navHome = "Home";
  static const String navSearch = "Search";
  static const String navLibrary = "Library";

  // Search screen
  static const String searchHint = "Search songs, artists, albums...";
  static const String searchInitialMessage = "Search for music";
  static const String searchRetry = "Retry";

  static String searchNoResults(String query) => 'No results for "$query"';

  static String playing(String title) => 'Playing: $title';

  static String more(String title) => 'More: $title';
}
