
import '../../../domain/entities/user/address_entity.dart';

class AddressModel extends AddressEntity {
  @override
  final String zipCode;
  @override
  final String street;
  @override
  final String number;
  @override
  final String complement;
  @override
  final String neighborhood;
  @override
  final String city;
  @override
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
}
