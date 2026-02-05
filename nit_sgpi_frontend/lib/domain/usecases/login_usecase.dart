import 'package:nit_sgpi_frontend/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<String> call(String email, String password) async{
    final token = await repository.login(email, password);
    await repository.saveToken(token);
    return token;
  }
}