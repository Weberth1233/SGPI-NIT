import 'package:dartz/dartz.dart';

import '../core/errors/failures.dart';
import '../repositories/iattachment_repository.dart';

class OpenAttachmentUseCase {
  final IAttachmentRepository repository;

  OpenAttachmentUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.openDocument(id);
  }
}
