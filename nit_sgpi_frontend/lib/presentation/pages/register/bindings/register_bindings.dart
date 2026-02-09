import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/iuser_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/post_user.dart';
import 'package:nit_sgpi_frontend/infra/datasources/user_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/repositories/user_repository.dart';
import 'package:nit_sgpi_frontend/presentation/pages/register/controllers/register_controller.dart';

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<IUserRemoteDataSource>(
      () => UserRemoteDatasourceImpl(http.Client()),
    );
    // Repository
    Get.lazyPut<IUserRepository>(
      () => UserRepository(remoteDataSource: Get.find<IUserRemoteDataSource>()),
    );
    // UseCase
    Get.lazyPut<PostUser>(
      () => PostUser(repository: Get.find<IUserRepository>()),
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find<PostUser>()),
    );
  }
}
