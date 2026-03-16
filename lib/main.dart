import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ymusic/app.dart';
import 'package:ymusic/core/services/isar_service.dart';
import 'package:ymusic/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Schemas are empty for now — each feature registers its own schema here.
  // Example (Phase 3.4): IsarService.initialize([SongSchema, ...])
  await IsarService.initialize([]);

  runApp(
    const ProviderScope(
      child: YMusicApp(),
    ),
  );
}
