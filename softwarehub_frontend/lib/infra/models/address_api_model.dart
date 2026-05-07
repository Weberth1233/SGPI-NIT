// MODEL
import '../../domain/entities/address_api_entity.dart';

class AddressApiModel {
   final String zipCode;
  final String street;
  final String complement;
  final String unit;
  final String neighborhood;
  final String city;
  final String stateCode;
  final String state;
  final String region;
  final String ibgeCode;
  final String giaCode;
  final String areaCode;
  final String siafiCode;

  const AddressApiModel({
    required this.zipCode,
    required this.street,
    required this.complement,
    required this.unit,
    required this.neighborhood,
    required this.city,
    required this.stateCode,
    required this.state,
    required this.region,
    required this.ibgeCode,
    required this.giaCode,
    required this.areaCode,
    required this.siafiCode,
  });

  factory AddressApiModel.fromJson(Map<String, dynamic> json) {
    return AddressApiModel(
      zipCode: json['cep'] ?? '',
      street: json['logradouro'] ?? '',
      complement: json['complemento'] ?? '',
      unit: json['unidade'] ?? '',
      neighborhood: json['bairro'] ?? '',
      city: json['localidade'] ?? '',
      stateCode: json['uf'] ?? '',
      state: json['estado'] ?? '',
      region: json['regiao'] ?? '',
      ibgeCode: json['ibge'] ?? '',
      giaCode: json['gia'] ?? '',
      areaCode: json['ddd'] ?? '',
      siafiCode: json['siafi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': zipCode,
      'logradouro': street,
      'complemento': complement,
      'unidade': unit,
      'bairro': neighborhood,
      'localidade': city,
      'uf': stateCode,
      'estado': state,
      'regiao': region,
      'ibge': ibgeCode,
      'gia': giaCode,
      'ddd': areaCode,
      'siafi': siafiCode,
    };
  }

  AddressApiEntity toEntity() {
    return AddressApiEntity(
      zipCode: zipCode,
      street: street,
      complement: complement,
      unit: unit,
      neighborhood: neighborhood,
      city: city,
      stateCode: stateCode,
      state: state,
      region: region,
      ibgeCode: ibgeCode,
      giaCode: giaCode,
      areaCode: areaCode,
      siafiCode: siafiCode,
    );
  }
}