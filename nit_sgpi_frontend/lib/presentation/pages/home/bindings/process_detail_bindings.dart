import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/presentation/pages/home/controllers/process_detail_controller.dart';

import '../../../../domain/repositories/ijustification_repository.dart';
import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../domain/usecases/delete_justification.dart';
import '../../../../domain/usecases/get_process_by_id.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/datasources/justiification_remote_datasource.dart';
import '../../../../infra/datasources/process_remote_datasource.dart';
import '../../../../infra/repositories/justification_repository_impl.dart';
import '../../../../infra/repositories/process_repository_impl.dart';

class ProcessDetailBindings extends Bindings{
  
  @override
  void dependencies() {
    // TODO: implement dependencies

    // Http client puro
    Get.lazyPut<http.Client>(() => http.Client());

    // Local datasource (token)
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());

    // ApiClient (usa http.Client + AuthLocalDataSource)
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<http.Client>(),
        Get.find<AuthLocalDataSource>(),
      ),
    );

    // Remote datasource
    Get.lazyPut<IProcessRemoteDataSource>(
      () => ProcessRemoteDataSourceImpl(Get.find<ApiClient>()),
    );

     Get.lazyPut<IJustificationRemoteDataSource>(
      () => JustificationRemoteDatasourceImpl(Get.find<ApiClient>()),
    );


    // Repository
    Get.lazyPut<IProcessRepository>(
      () => ProcessRepositoryImpl(
        remoteDataSource: Get.find<IProcessRemoteDataSource>(),
      ),
    );

    Get.lazyPut<IJustificationRepository>(
      () => JustificationRepositoryImpl(
        remoteDataSource: Get.find<IJustificationRemoteDataSource>(),
      ),
    );
    
Get.lazyPut<DeleteJustification>(
      () => DeleteJustification(
        repository: Get.find<IJustificationRepository>(),
      ),
    );


    // UseCase
    Get.lazyPut<GetProcessById>(
      () => GetProcessById(
        repository: Get.find<IProcessRepository>(),
      ),
    );

  // Controller
    Get.lazyPut<ProcessDetailController>(
      () => ProcessDetailController(Get.find<GetProcessById>(), Get.find<AuthLocalDataSource>(), Get.find<DeleteJustification>()),
    );

  }

}