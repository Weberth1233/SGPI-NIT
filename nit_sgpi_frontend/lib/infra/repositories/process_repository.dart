import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_status_count_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iprocess_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/process_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/models/paged_result_model.dart';

class ProcessRepository implements IProcessRepository {
  final IProcessRemoteDataSource remoteDataSource;

  ProcessRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedResultEntity<ProcessEntity>>> getProcesses({
    String title = "",
    String statusGenero = "",
    int page = 0,
    int size = 10,
  }) async {
    try {
      final PagedProcessResultModel resultModel = await remoteDataSource
          .getProcesses(
            title: title,
            statusProcess: statusGenero,
            page: page,
            size: size,
          );
      // 👇 CONVERSÃO MODEL -> ENTITY
      final PagedResultEntity<ProcessEntity> resultEntity = resultModel
          .toEntity();
      return Right(resultEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }

  @override
  Future<Either<Failure, List<ProcessStatusCountEntity>>>
  getProcessesStatus() async {
    try {
      final result = await remoteDataSource.getProcessesStatusCount();
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
