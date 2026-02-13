import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iattachment_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/attachment_datasource.dart';

import '../../domain/core/errors/exceptions.dart';

class AttachmentRepositoryImpl implements IAttachmentRepository{
  final IAttachmentDatasource remoteDataSource;

  AttachmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> openDocument(int id) async{
    try {
      final result = await remoteDataSource.openDocument(id);
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
  Future<Either<Failure, List<AttachmentEntity>>> getAttachments(int idProcess) async{
    try {
      final result = await remoteDataSource.getAttachments(idProcess);
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
  Future<Either<Failure, String>> uploadDocument({required int id, String? filePath, Uint8List? fileBytes, required String fileName})async {
    try {
      final result = await remoteDataSource.uploadDocument(id: id, fileName: fileName, fileBytes: fileBytes, filePath: filePath);
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