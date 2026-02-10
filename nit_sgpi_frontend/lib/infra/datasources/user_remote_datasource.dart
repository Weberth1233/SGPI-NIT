import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/infra/models/user/user_post_model.dart';
import 'package:nit_sgpi_frontend/infra/utils/error_formatter%20.dart';
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
      Uri.parse('${BaseUrl.urlWithHttp}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 201) {
      return "Cadastrado com sucesso!";
    } 
    else if (response.statusCode == 422) {
      // 👇 transforma o JSON de erro em string bonita
      return ApiErrorFormatter.formatFromBody(response.body);
    } 
    else {
      throw ServerException(
        'Erro ${response.statusCode} erro no cadastro! - Detalhes: ${response.body}',
      );
    }
  } catch (e) {
    print(e);
    throw NetworkException('Erro de conexão com o servidor!');
  }
}

}
