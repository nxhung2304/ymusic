import 'package:fpdart/fpdart.dart';
import 'package:ymusic/core/data/datasources/youtube_datasource.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/error/failures.dart';
import 'package:ymusic/features/search/domain/entities/song.dart';
import 'package:ymusic/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final YouTubeDatasource youtubeDatasource;

  SearchRepositoryImpl(this.youtubeDatasource);

  @override
  Future<Either<Failure, List<Song>>> search(String query) async {
    try {
      final songs = await youtubeDatasource.search(query);

      return right(songs);
    } on AppException catch (e) {
      return left(e.toFailure());
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
