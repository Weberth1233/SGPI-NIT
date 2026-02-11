import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_types/ip_type_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iip_types_repository.dart';

import '../core/errors/failures.dart';

class GetIptypes {
  final IipTypesRepository repository;

  GetIptypes({required this.repository});

  Future<Either<Failure, List<IpTypeEntity>>> call() {
    return repository.getIpTypes();
  }
}
