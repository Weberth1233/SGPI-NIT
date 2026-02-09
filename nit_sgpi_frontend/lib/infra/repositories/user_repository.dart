import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iuser_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/user_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_post_model.dart';
import '../../domain/core/errors/exceptions.dart';

class UserRepository implements IUserRepository {
  final IUserRemoteDataSource remoteDataSource;

  UserRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> postUser(UserPostModel userEntity) async {
    try {
      final result = await remoteDataSource.postUser(userEntity);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
}
