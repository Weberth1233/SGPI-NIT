import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/address_api_entity.dart';

import '../core/errors/failures.dart';

abstract class IAddressRepository {
  Future<Either<Failure, AddressApiEntity>> getByZipCode(String zipCode);
}