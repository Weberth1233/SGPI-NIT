import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/iregister_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/post_user.dart';
import 'package:nit_sgpi_frontend/infra/datasources/register_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/repositories/register_repository_impl.dart';
import 'package:nit_sgpi_frontend/presentation/pages/register/controllers/register_controller.dart';

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<IRegisterRemoteDataSource>(
      () => RegisterRemoteDatasource(http.Client()),
    );
    // Repository
    Get.lazyPut<IRegisterRepository>(
      () => RegisterRepositoryImpl(remoteDataSource: Get.find<IRegisterRemoteDataSource>()),
    );
    // UseCase
    Get.lazyPut<PostUser>(
      () => PostUser(repository: Get.find<IRegisterRepository>()),
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find<PostUser>()),
    );
  }
}
