import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iexternal_author_repository.dart';

import '../core/errors/failures.dart';
import '../entities/paged_result_entity.dart';

class GetExternalAuthors {
  final IExternalAuthorRepository repository;

  GetExternalAuthors({required this.repository});

  Future<Either<Failure, PagedResultEntity<ExternalAuthorEntity>>> call({
    String fullName ="",
    String email = "",
    String cpf = "",
    int page = 0,
    int size = 10,
  }) {
    return repository.getExternalAuthors(fullName:fullName,email: email,cpf: cpf, page: page,size: size);
  }
}