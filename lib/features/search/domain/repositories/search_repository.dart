import 'package:fpdart/fpdart.dart';
import 'package:ymusic/core/error/failures.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Song>>> search(String query);
}
