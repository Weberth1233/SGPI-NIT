import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_model.dart';
import 'package:nit_sgpi_frontend/infra/utils/error_formatter%20.dart';
import '../../domain/core/errors/exceptions.dart';

import '../core/network/base_url.dart';

abstract class IRegisterRemoteDataSource {
  Future<String> postUser(UserEntity user);

}

class RegisterRemoteDatasource implements IRegisterRemoteDataSource {
  final http.Client client;

  RegisterRemoteDatasource(this.client);

  @override
  Future<String> postUser(UserEntity user) async {
  try {
    //Trasnformando entidade user em uma variavel de modelo
    final model = UserModel.fromEntity(user); 
    final response = await client.post(
      Uri.parse('${BaseUrl.urlWithHttp}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
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
