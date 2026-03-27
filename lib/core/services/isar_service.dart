import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ymusic/core/error/exceptions.dart';

/// Shared singleton wrapper for the local Isar database.
///
/// Usage:
///   1. Call [initialize] once at app startup (in main.dart).
///   2. Access the [instance] getter anywhere to obtain the open [Isar] db.
///   3. Call [close] when the app is disposing.
class IsarService {
  IsarService._();

  static Isar? _instance;

  /// Opens the Isar database with [schemas] and stores it as the singleton.
  ///
  /// If [schemas] is empty, this is a no-op — the database will be opened once
  /// a feature registers its schema. This allows calling `initialize([])` at
  /// app startup before any feature schemas are available.
  ///
  /// If already initialized, returns immediately (idempotent).
  /// Pass [directoryOverride] in tests to avoid relying on path_provider.
  static Future<void> initialize(
    List<CollectionSchema<dynamic>> schemas, {
    @visibleForTesting String? directoryOverride,
  }) async {
    if (_instance != null) return;
    if (schemas.isEmpty) return;

    try {
      final dir = directoryOverride ??
          (await getApplicationDocumentsDirectory()).path;

      _instance = await Isar.open(schemas, directory: dir);
    } catch (e) {
      throw IsarException('initialize failed', cause: e);
    }
  }

  /// Returns the open [Isar] instance.
  ///
  /// Throws [IsarException] if [initialize] has not been called yet.
  static Isar get instance {
    if (_instance == null) {
      throw const IsarException(
        'IsarService is not initialized. Call IsarService.initialize() first.',
      );
    }

    return _instance!;
  }

  /// Closes the database and resets the singleton.
  static Future<void> close() async {
    try {
      await _instance?.close();
      _instance = null;
    } catch (e) {
      throw IsarException('close failed', cause: e);
    }
  }
}
