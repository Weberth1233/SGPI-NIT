import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_post_model.dart';

import '../core/errors/failures.dart';

abstract class IUserRepository {
    Future<Either<Failure, String>> postUser(UserPostModel userEntity);
}