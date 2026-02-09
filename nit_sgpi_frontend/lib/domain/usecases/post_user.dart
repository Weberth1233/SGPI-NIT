import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iuser_repository.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_post_model.dart';
import '../core/errors/failures.dart';

class PostUser {
  final IUserRepository repository;

  PostUser({required this.repository});

  Future<Either<Failure, String>> call(UserPostModel user) async{
    final result = await repository.postUser(user);
    return result;
  }
}