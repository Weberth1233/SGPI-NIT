import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/auth_user_entity.dart';

import '../core/errors/failures.dart';

abstract class AuthRepository {
  Future<AuthUserEntity> login(String email, String password);
  Future<void> saveToken(String token);
  Future<void> saveRole(String token);
  Future<String?> getToken();
  Future<String?> getRole();
  Future<void> logout();
  Future<Either<Failure, String>> forgotPassword(String email);
  
}