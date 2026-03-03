import 'package:get/get.dart';
import '../../../../../domain/usecases/login_usecase.dart';
import '../../../../shared/controller/auth_controller.dart';

class LoginController extends GetxController {
  final LoginUsecase loginUseCase;

  LoginController(this.loginUseCase);

  RxBool loading = false.obs;
  RxString errorMessage = "".obs;

  Future<void> login(String email, String password) async {
    loading.value = true;
    errorMessage.value = "";

    try {
      final user = await loginUseCase(email, password);
      final authController = Get.find<AuthController>();
      await authController.loadSession();

      Get.offAllNamed("/home");
    } catch (e) {
      errorMessage.value = "Login ou senha inválidos!";
    } finally {
      loading.value = false;
    }
  }
}