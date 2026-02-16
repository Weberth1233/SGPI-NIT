import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import 'package:nit_sgpi_frontend/infra/models/justification_request_model.dart';
import '../core/network/api_client.dart';

abstract class IJustificationRemoteDataSource{
  Future<String> postJustification(JustificationRequestEntity justification);
}

class JustificationRemoteDatasourceImpl implements IJustificationRemoteDataSource {
  final ApiClient apiClient;

  JustificationRemoteDatasourceImpl(this.apiClient);
  
  @override
  Future<String> postJustification(JustificationRequestEntity justification) async {
    try{
      final model = JustificationRequestModel.fromEntity(justification);

      final response = await apiClient.post("${BaseUrl.urlWithHttp}/justification",
      body: model.toJson(),
      );
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 201) {
        return "Cadastrado com sucesso!";
      } else if (response.statusCode == 422) {
        // 👇 transforma o JSON de erro em string bonita
        return response.body;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} erro no cadastro! - Detalhes: ${response.body}',
        );
      }
    }catch(e){
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  
}