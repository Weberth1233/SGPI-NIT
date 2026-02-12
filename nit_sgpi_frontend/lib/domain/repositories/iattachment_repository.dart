import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';

abstract class IattachmentRepository {
  Future<Either<Failure, void>> getDocument(int id);
}