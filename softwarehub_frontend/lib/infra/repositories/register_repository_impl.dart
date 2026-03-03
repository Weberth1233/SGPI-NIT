import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iregister_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/register_remote_datasource.dart';
import '../../domain/core/errors/exceptions.dart';

class RegisterRepositoryImpl implements IRegisterRepository {
  final IRegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> postUser(UserEntity userEntity) async {
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
  
  @override
  Future<Either<Failure, UserEntity>> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}
