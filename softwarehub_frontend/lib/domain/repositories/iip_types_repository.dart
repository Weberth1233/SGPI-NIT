import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_types/ip_type_entity.dart';

import '../core/errors/failures.dart';

abstract class IipTypesRepository {
  Future<Either<Failure, List<IpTypeEntity>>> getIpTypes();
}