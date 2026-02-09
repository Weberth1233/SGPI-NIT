import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/infra/models/user/user_post_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/network/base_url.dart';

abstract class IUserRemoteDataSource {
  Future<String> postUser(UserPostModel user);
}

class UserRemoteDatasourceImpl implements IUserRemoteDataSource {
  final http.Client client;

  UserRemoteDatasourceImpl(this.client);

  @override
  Future<String> postUser(UserPostModel user) async {
    try {
      final response = await client.post(
        Uri.parse('${BaseUrl.url}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: user.toJson(),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 204) {
        return "Cadastrado com sucesso!";
      } else {
        throw ServerException(
          'Erro ${response.statusCode} erro no cadastro! - Detalhes: ${response.body}',
        );
      }
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
