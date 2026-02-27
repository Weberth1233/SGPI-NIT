import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/entities/auth_user_entity.dart';
import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';

import '../../domain/core/errors/exceptions.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthUserEntity> login(String email, String password);
  Future<String> forgotPassword(String email);
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource(this.client);

  @override
  Future<AuthUserEntity> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${BaseUrl.urlWithHttp}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      AuthUserEntity userEntity = AuthUserEntity(
        token: json['token'],
        role: json['role'],
      );
      return userEntity;
    } else {
      throw Exception('Erro ao fazer login: ${response.body}');
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    try {
      final response = await client.post(
        Uri.parse('${BaseUrl.urlWithHttp}/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json['message']);
        return json['message'];
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!$e');
    }
  }
}
