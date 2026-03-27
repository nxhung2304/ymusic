import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/datasources/youtube_datasource.dart';
import 'package:ymusic/core/services/firestore_service.dart';
import 'package:ymusic/core/services/isar_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'app_providers.g.dart';

@riverpod
FirestoreService firestoreService(Ref ref) => FirestoreService();

@riverpod
Isar isarService(Ref ref) => IsarService.instance;

@riverpod
YouTubeDatasource youTubeDatasource(Ref ref) => YouTubeDatasource(YoutubeExplode());
