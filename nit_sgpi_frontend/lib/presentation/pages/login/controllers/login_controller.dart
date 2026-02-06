import 'package:get/get.dart';

import '../../../../domain/usecases/login_usecase.dart';

class LoginController extends GetxController {
  final LoginUsecase loginUseCase;

  LoginController(this.loginUseCase);

  RxBool loading = false.obs;
  RxBool successLogin = false.obs;
  RxString errorMessage = "".obs;

  Future<void> login(String email, String password) async {
    loading.value = true;
    errorMessage.value = "";
    try {
      await loginUseCase(email, password);
      successLogin.value = true;
      Get.offAllNamed("/home");
    } catch (e) {
      errorMessage.value = "Login ou senha inválidos!";
    } finally {
      loading.value = false;
    }
  }
}
