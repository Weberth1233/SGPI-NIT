import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification_request_entity.dart';
import '../core/errors/failures.dart';

abstract class IJustificationRepository {
   Future<Either<Failure, String>> postJustification(JustificationRequestEntity entity);
   Future<Either<Failure, String>> deleteJustification(int idJustification);

   Future<Either<Failure, String>> putJustification(int idJustification, JustificationRequestEntity justification);



}