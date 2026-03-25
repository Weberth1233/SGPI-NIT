import 'dart:math';

import 'package:dartz/dartz.dart';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/external_author/external_author_entity.dart';
import '../../domain/entities/paged_result_entity.dart';
import '../../domain/repositories/iexternal_author_repository.dart';
import '../datasources/external_author_datasource.dart';

class ExternalAuthorRepositoryImpl implements IExternalAuthorRepository{

  final IExternalAuthorRemoteDataSource remoteDataSource;

  ExternalAuthorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedResultEntity<ExternalAuthorEntity>>> getExternalAuthors({String fullName = "", String email="", String cpf="", int page = 0, int size = 10}) async{
     try{
      final resultEntity = await remoteDataSource.getExternalAuthors(fullName: fullName, email: email, cpf: cpf, size: size, page: page);
      return Right(resultEntity);
    }on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
  
  @override
  Future<Either<Failure, String>> postExternalAuthor(ExternalAuthorEntity entity) async{
    try {
      final result = await remoteDataSource.postExternalAuthor(entity);
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
  Future<Either<Failure, String>> deleteExternalAuthor(int id) async{
    try {
      final result = await remoteDataSource.deleteExternalAuthor(
        id,
      );
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
  Future<Either<Failure, String>> putExternalAuthor(int id, ExternalAuthorEntity entity) async{
    try {
      final result = await remoteDataSource.putExternalAuthor(
        id,
        entity
      );
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