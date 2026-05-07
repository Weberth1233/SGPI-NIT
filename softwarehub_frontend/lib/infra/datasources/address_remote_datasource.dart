import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/infra/models/address_api_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/entities/address_api_entity.dart';

abstract class IAddressRemoteDataSource {
  Future<AddressApiEntity> getByZipCode(String zipCode);
}
class AddressRemoteDataSource implements IAddressRemoteDataSource {
  final http.Client client;

  AddressRemoteDataSource(this.client);

  @override
  Future<AddressApiEntity> getByZipCode(String zipCode) async {
    try {
      final response = await client.get(
        Uri.parse('https://viacep.com.br/ws/$zipCode/json/'),
        headers: {'Content-Type': 'application/json'},
      );
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        AddressApiEntity addressApiEntity =  AddressApiModel.fromJson(json).toEntity();
        return addressApiEntity;
      } else{
       throw ServerException(
           'Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!$e');
    }
  }
}
