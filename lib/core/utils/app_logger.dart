import 'package:flutter/foundation.dart';

/// Centralized logger. Only outputs in debug mode.
/// Automatically detects the calling class and method from the stack trace.
///
/// Usage:
/// ```dart
/// AppLogger.d('fetching stream...');
/// AppLogger.i('user signed in');
/// AppLogger.w('cache miss');
/// AppLogger.e('request failed', error, stackTrace);
/// ```
/// Output format: `🐛 [YoutubeService#fetchStream] fetching stream...`
class AppLogger {
  AppLogger._();

  static void d(String message) {
    if (!kDebugMode) return;

    debugPrint('[${_caller()}] $message');
  }

  static void i(String message) {
    if (!kDebugMode) return;

    debugPrint('[${_caller()}] $message');
  }

  static void w(String message) {
    if (!kDebugMode) return;

    debugPrint('[${_caller()}] $message');
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (!kDebugMode) return;

    debugPrint('[${_caller()}] $message');

    if (error != null) {
      debugPrint('error: $error');
    }

    if (stackTrace != null) {
      debugPrint('stackTrace: $stackTrace');
    }
  }

  // ---------------------------------------------------------------------------

  /// Parses the caller's [ClassName#methodName] from the current stack trace.
  ///
  /// Frame layout when called from d/i/w/e:
  ///   #0  _caller       ← this method
  ///   #1  AppLogger.d   ← the log method
  ///   #2  Foo.bar       ← actual caller  ✅
  static String _caller() {
    const callerFrameIndex = 2;
    final frames = StackTrace.current.toString().split('\n');

    if (frames.length <= callerFrameIndex) return 'unknown#unknown';

    final frame = frames[callerFrameIndex];

    // Dart frame format: `#2      ClassName.methodName (file:line:col)`
    final match = RegExp(r'#\d+\s+(\S+)\s+\(').firstMatch(frame);
    if (match == null) return 'unknown#unknown';

    final symbol = match.group(1)!; // e.g. "YoutubeService.fetchStream"
    final dotIndex = symbol.indexOf('.');

    if (dotIndex == -1) return '$symbol#unknown';

    final className = symbol.substring(0, dotIndex);
    final method = symbol.substring(dotIndex + 1).split('.').first;

    return '$className#$method';
  }
}
