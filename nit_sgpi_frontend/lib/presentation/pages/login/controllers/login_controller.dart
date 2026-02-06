
import '../../../../domain/usecases/login_usecase.dart';

class LoginController {
  final LoginUsecase loginUseCase;

  LoginController(this.loginUseCase);

  Future<bool> login(String email, String password) async {
    try {
      await loginUseCase(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
