import 'package:get/get.dart';
import 'package:http/http.dart' as http show Client;
import 'package:nit_sgpi_frontend/domain/usecases/get_process.dart';
import 'package:nit_sgpi_frontend/infra/datasources/process_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/repositories/process_repository.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/controllers/home_controller.dart';
import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
class HomeBindings extends Bindings {
  @override
  void dependencies() {
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

    // Repository
    Get.lazyPut<IProcessRepository>(
      () => ProcessRepository(
        remoteDataSource: Get.find<IProcessRemoteDataSource>(),
      ),
    );

    // UseCase
    Get.lazyPut<GetProcesses>(
      () => GetProcesses(
        repository: Get.find<IProcessRepository>(),
      ),
    );

    // Controller
    Get.lazyPut<ProcessController>(
      () => ProcessController(Get.find<GetProcesses>()),
    );
  }
}
