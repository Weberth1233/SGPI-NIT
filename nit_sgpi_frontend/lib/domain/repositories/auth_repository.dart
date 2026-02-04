abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> logout();
  
}