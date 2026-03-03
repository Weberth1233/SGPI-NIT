import 'package:dartz/dartz.dart';

import '../core/errors/failures.dart';
import '../entities/paged_result_entity.dart';
import '../entities/user/user_entity.dart';

abstract class IUserRepository {
   Future<Either<Failure, PagedResultEntity<UserEntity>>> getUsers({String userName, String fullName, int page = 0, int size = 10});
   Future<Either<Failure, UserEntity>> getUserLogged();
   Future<Either<Failure, String>> updateUser(int idUser, UserEntity user);
   
}