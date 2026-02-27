import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/iregister_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/post_user.dart';
import 'package:nit_sgpi_frontend/infra/datasources/register_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/repositories/register_repository_impl.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/register/controllers/register_controller.dart';
import 'package:nit_sgpi_frontend/presentation/pages/users/controllers/user_logged_controller.dart' show UserLoggedController;

import '../../../../../domain/repositories/iuser_repository.dart';
import '../../../../../domain/usecases/get_user_logged.dart';
import '../../../../../domain/usecases/put_user.dart';
import '../../../../../infra/core/network/api_client.dart';
import '../../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../../infra/datasources/user_remote_datasources.dart';
import '../../../../../infra/repositories/user_repository_impl.dart';

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
   
    //uPDTAE
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
    Get.lazyPut<IUserRemoteDataSource>(
      () => UserRemoteDatasourcesImpl(Get.find<ApiClient>()),
    );

    // Repository
    Get.lazyPut<IUserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<IUserRemoteDataSource>(),
      ),
    );
      // UseCase
    Get.lazyPut<GetUserLogged>(
      () => GetUserLogged(
        repository: Get.find<IUserRepository>(),
      ),
    );
    
    Get.lazyPut<PutUser>(
      () => PutUser(
        repository: Get.find<IUserRepository>(),
      ),
    );
    // Controller
    Get.lazyPut<UserLoggedController>(
      () => UserLoggedController(Get.find<GetUserLogged>()),
    );
    
     Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find<PostUser>(), Get.find<PutUser>()),
    );
   
  }
}
