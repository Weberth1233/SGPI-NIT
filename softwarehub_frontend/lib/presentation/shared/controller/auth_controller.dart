import 'package:get/get.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;

  AuthController(this.repository);

  final RxnString _token = RxnString();
  final RxnString _role = RxnString();

  String? get token => _token.value;
  String? get role => _role.value;

  bool get isAuthenticated => _token.value != null;

  Future<void> loadSession() async {
    _token.value = await repository.getToken();
    _role.value = await repository.getRole();
  }

  Future<void> saveSession(String token, String role) async {
    await repository.saveToken(token);
    await repository.saveRole(role);

    _token.value = token;
    _role.value = role;
  }

  Future<void> logout() async {
    await repository.logout();
    _token.value = null;
    _role.value = null;

    Get.offAllNamed('/unauthenticated');
  }
}