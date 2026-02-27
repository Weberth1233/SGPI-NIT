import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/auth_user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.remote, this.local);

  @override
  Future<AuthUserEntity> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<void> saveToken(String token) {
    return local.saveToken(token);
  }

  @override
  Future<String?> getToken() {
    return local.getToken();
  }

  @override
  Future<void> logout() {
    return local.clear();
  }
  
  @override
  Future<String?> getRole() {
    return local.getRole();
  }
  
  @override
  Future<void> saveRole(String role) {
    return local.saveRole(role);
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async{
    try {
      final result = await remote.forgotPassword(email);
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
