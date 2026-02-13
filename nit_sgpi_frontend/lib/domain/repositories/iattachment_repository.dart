import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import '../core/errors/failures.dart';

abstract class IAttachmentRepository {
  Future<Either<Failure, void>> openDocument(int id);
  Future<Either<Failure, List<AttachmentEntity>>> getAttachments(int idProcess);
}