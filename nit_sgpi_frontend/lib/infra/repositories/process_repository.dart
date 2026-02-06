import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iprocess_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/process_remote_datasource.dart';

class ProcessRepository implements IProcessRepository{
  
  final IProcessRemoteDataSource remoteDataSource;

  ProcessRepository({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, PagedResultEntity<ProcessEntity>>> getProcesses({int page = 0, int size = 10}) async{
    try{
      final result = await remoteDataSource.getProcesses(page: page, size: size);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.message));
    }on NetworkException catch(e){
      return Left(NetworkFailure(e.message));
    }
    catch(e){
      return Left(ServerFailure("Erro inesperado!"));
    } 
  }
}