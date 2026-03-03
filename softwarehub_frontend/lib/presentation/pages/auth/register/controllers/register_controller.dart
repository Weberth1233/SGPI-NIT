import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/post_user.dart';

import '../../../../../domain/core/errors/failures.dart';
import '../../../../../domain/usecases/put_user.dart';

class RegisterController extends GetxController{
  final PostUser _postUser;
  final PutUser _putUser;

  RegisterController(this._postUser, this._putUser);
  RxBool isLoading = false.obs;
  RxString message = "".obs;

  Future<void> post(UserEntity user) async {
    if (isLoading.value) return;
    isLoading.value = true;
    message.value = '';
    final result = await _postUser(
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


  Future<void> updateUserLogged(int idUser, UserEntity user) async {
    isLoading.value = true;
    message.value = "";

    final result = await _putUser(idUser, user);

    result.fold(
      (failure) {
        message.value = failure.message;
      },
      (sucess) {
        message.value = sucess;
        

      },  
    );

    isLoading.value = false;
  }
}