// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'YMusic';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSave => 'Save';

  @override
  String get actionClose => 'Close';

  @override
  String get actionPlay => 'Play';

  @override
  String get actionPause => 'Pause';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorUnknown => 'An unknown error occurred. Please try again.';

  @override
  String get errorUnauthorized => 'You are not authorized. Please sign in again.';

  @override
  String get errorNotFound => 'The requested resource was not found.';

  @override
  String get errorTimeout => 'The request timed out. Please try again.';

  @override
  String get labelLoading => 'Loading...';

  @override
  String get labelNoResults => 'No results found.';

  @override
  String get labelNoInternet => 'No internet connection.';
}
