import 'package:intl/intl.dart';

class DurationFormatter {
  static String format(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return DateFormat('mm:ss').format(
      DateTime(0).add(Duration(minutes: minutes, seconds: seconds)),
    );
  }
}
