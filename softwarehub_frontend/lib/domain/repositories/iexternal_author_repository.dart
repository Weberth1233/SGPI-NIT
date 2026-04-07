import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';
import '../entities/external_author/external_author_entity.dart';
import '../entities/paged_result_entity.dart';

abstract class IExternalAuthorRepository {
  Future<Either<Failure, PagedResultEntity<ExternalAuthorEntity>>> getExternalAuthors({String search, int page = 0, int size = 10});
  Future<Either<Failure, String>> postExternalAuthor(ExternalAuthorEntity entity);
  Future<Either<Failure, String>> deleteExternalAuthor(int id);
  Future<Either<Failure, String>> putExternalAuthor(int id,ExternalAuthorEntity entity);
}