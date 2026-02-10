import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/post_user.dart';

import '../../../../domain/core/errors/failures.dart';

class RegisterController extends GetxController{
  final PostUser postUser;

  RegisterController(this.postUser);
  RxBool isLoading = false.obs;
  RxString message = "".obs;

  Future<void> post(UserEntity user) async {
    if (isLoading.value) return;
    isLoading.value = true;
    message.value = '';
    final result = await postUser(
      user
    );
    result.fold(
      (Failure failure) {
        
        message.value = failure.message;
      },
      (sucess) {
        message.value = sucess;
      },
    );
    isLoading.value = false;
  }
}