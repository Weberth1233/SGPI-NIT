import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iuser_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/user_remote_datasources.dart';
import 'package:nit_sgpi_frontend/infra/models/user/peged_user_result_model.dart';

import '../../domain/core/errors/exceptions.dart';

class UserRepositoryImpl implements IUserRepository{

  final IUserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedResultEntity<UserEntity>>> getUsers({String userName = "", String fullName= "", int page = 0, int size = 10}) async{
    try{
      final PagedUserResultModel resultModel = await remoteDataSource.getUsers(fullName: fullName, userName: userName, size: size, page: page);
      final PagedResultEntity<UserEntity> resultEntity = resultModel.toEntity();
      return Right(resultEntity);
    }on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }


}