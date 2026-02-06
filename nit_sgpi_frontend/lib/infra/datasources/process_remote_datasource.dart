import 'dart:convert';

import 'package:nit_sgpi_frontend/infra/core/network/api_client.dart';

import '../../domain/core/errors/exceptions.dart';
import '../models/paged_result_model.dart';

abstract class IProcessRemoteDataSource {
  Future<PagedProcessResultModel> getProcesses({
    int page = 0,
    int size = 10,
  });
}

class ProcessRemoteDataSourceImpl implements IProcessRemoteDataSource {
  final ApiClient apiClient;

  ProcessRemoteDataSourceImpl(this.apiClient);
  
  @override
  Future<PagedProcessResultModel> getProcesses({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await apiClient.get('http://localhost:8080/process/user/processes?page=$page&page-size=$size');
      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return PagedProcessResultModel.fromJson(jsonMap);
      } else {
        throw ServerException('Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}');
      }
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
