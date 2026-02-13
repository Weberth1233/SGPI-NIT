import 'package:nit_sgpi_frontend/domain/entities/auth_user_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<AuthUserEntity> call(String email, String password) async{
    final authUser = await repository.login(email, password);
    await repository.saveToken(authUser.token);
    await repository.saveRole(authUser.role);
    return authUser;
  }
}