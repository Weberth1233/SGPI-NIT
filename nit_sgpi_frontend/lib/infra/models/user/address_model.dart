import '../../../domain/entities/user/address_entity.dart';

class AddressModel {
  final String zipCode;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  AddressModel({
    required this.zipCode,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  /// Converte AddressEntity -> AddressModel
  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      zipCode: entity.zipCode,
      street: entity.street,
      number: entity.number,
      complement: entity.complement,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      zipCode: json['zipCode'],
      street: json['street'],
      number: json['number'],
      complement: json['complement'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      state: json['state'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "zipCode": zipCode,
      "street": street,
      "number": number,
      "complement": complement,
      "neighborhood": neighborhood,
      "city": city,
      "state": state,
    };
  }

  AddressEntity toEntity() {
    return AddressEntity(
      city: city,
      complement: complement,
      neighborhood: neighborhood,
      number: number,
      state: state,
      street: street,
      zipCode: zipCode,
    );
  }
}
