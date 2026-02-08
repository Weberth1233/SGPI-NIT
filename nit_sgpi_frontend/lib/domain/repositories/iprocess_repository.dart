import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_status_count_entity.dart';

abstract class IProcessRepository {
  Future<Either<Failure, PagedResultEntity<ProcessEntity>>> getProcesses({String title,String statusGenero, int page = 0, int size = 10});
  Future<Either<Failure, List<ProcessStatusCountEntity>>> getProcessesStatus();


}