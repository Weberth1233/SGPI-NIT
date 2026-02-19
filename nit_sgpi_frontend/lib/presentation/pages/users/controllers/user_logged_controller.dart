import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_user_logged.dart';

import '../../../../domain/entities/user/user_entity.dart';

class UserLoggedController extends GetxController {
  final GetUserLogged getUserLogged;

  UserLoggedController(this.getUserLogged);

  var user = Rxn<UserEntity>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoggedUser();
  }

  Future<void> fetchLoggedUser() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getUserLogged();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (userEntity) {
        user.value = userEntity;
      },
    );

    isLoading.value = false;
  }
}
