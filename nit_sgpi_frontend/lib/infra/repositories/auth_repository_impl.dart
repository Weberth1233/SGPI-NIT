import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.remote, this.local);

  @override
  Future<String> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<void> saveToken(String token) {
    return local.saveToken(token);
  }

  @override
  Future<String?> getToken() {
    return local.getToken();
  }

  @override
  Future<void> logout() {
    return local.clearToken();
  }
}
