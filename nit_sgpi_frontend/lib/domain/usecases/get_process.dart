import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';
import '../entities/paged_result_entity.dart';
import '../entities/process/process_entity.dart';
import '../repositories/iprocess_repository.dart';


class GetProcesses {
  final IProcessRepository repository;

  GetProcesses({required this.repository});

  Future<Either<Failure, PagedResultEntity<ProcessEntity>>> call({
    int page = 0,
    int size = 10,
  }) {
    return repository.getProcesses(page: page, size: size);
  }
}
