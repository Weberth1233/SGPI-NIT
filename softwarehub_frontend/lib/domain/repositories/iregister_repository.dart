import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';

import '../core/errors/failures.dart';

abstract class IRegisterRepository {
    Future<Either<Failure, String>> postUser(UserEntity userEntity);
}