import 'dart:convert';

import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_model.dart';

import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../models/user/peged_user_result_model.dart';

abstract class IUserRemoteDataSource {
  Future<PagedUserResultModel> getUsers({
    String userName = '',
    String fullName = '',
    int page = 0,
    int size = 10,
  });

  Future<UserEntity> getUserLogged();
}

class UserRemoteDatasourcesImpl implements IUserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDatasourcesImpl(this.apiClient);
  
  @override
  Future<PagedUserResultModel> getUsers({
    String userName = '',
    String fullName = '',
    int page = 0,
    int size = 10,
  }) async{
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page-size': size.toString(),
      };

      if (userName.isNotEmpty) {
        queryParams['user-name'] = userName;
      }

      if (fullName.isNotEmpty) {
        queryParams['full-name'] = fullName;
      }

      final uri = Uri.http(
        BaseUrl.url,
        '/users',
        queryParams,
      );

      final response = await apiClient.get(uri.toString());

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return PagedUserResultModel.fromJson(jsonMap);
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar usuarios! - Detalhes: ${response.body}',
        );
      }
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
  
  @override
  Future<UserEntity> getUserLogged() async{
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/users/logged",
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body)).toEntity();  
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
