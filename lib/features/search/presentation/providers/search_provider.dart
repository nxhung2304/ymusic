import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/core/providers/app_providers.dart';
import 'package:ymusic/features/search/data/repositories/search_repository_impl.dart';
import 'package:ymusic/features/search/domain/repositories/search_repository.dart';

part 'search_provider.g.dart';

@riverpod
SearchRepository searchRepository(Ref ref) =>
    SearchRepositoryImpl(ref.read(youTubeDatasourceProvider));
