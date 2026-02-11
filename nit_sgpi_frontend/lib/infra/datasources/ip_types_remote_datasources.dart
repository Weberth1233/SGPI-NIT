import 'dart:convert';

import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import 'package:nit_sgpi_frontend/infra/models/ip_types/ip_types_model.dart';

import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';

abstract class IipTypesRemoteDataSource{
  Future<List<IpTypeModel>> getIpTypes();
}
class IipTypesRemoteDataSourceImpl implements IipTypesRemoteDataSource{
   final ApiClient apiClient;

  IipTypesRemoteDataSourceImpl(this.apiClient);
   
  @override
  Future<List<IpTypeModel>> getIpTypes() async{
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/ip_types",
      );

      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body) as List;

        return decoded
            .map(
              (e) =>
                  IpTypeModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
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