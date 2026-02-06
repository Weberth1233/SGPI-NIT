import 'dart:convert';

import 'package:http/http.dart' as http show Client;

import '../../domain/core/errors/exceptions.dart';
import '../models/paged_result_model.dart';

abstract class ProcessRemoteDataSource {
  Future<PagedProcessResultModel> getProcesses({
    int page = 0,
    int size = 10,
  });
}

class ProcessRemoteDataSourceImpl implements ProcessRemoteDataSource {
  final http.Client client;

  ProcessRemoteDataSourceImpl(this.client);
  
  @override
  Future<PagedProcessResultModel> getProcesses({
    int page = 0,
    int size = 10,
  }) async {
    final url = Uri.parse('http://localhost:8080/process/user/processes?page=$page&page-size=$size');
    try {
      final response = await client.get(url);
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
