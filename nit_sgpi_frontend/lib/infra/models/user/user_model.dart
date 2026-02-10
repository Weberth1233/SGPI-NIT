import 'package:nit_sgpi_frontend/infra/models/user/address_model.dart';
import '../../../domain/entities/user/user_entity.dart';

class UserModel {
  final String userName;
  final String email;
  final String password;
  final String phoneNumber;
  final String birthDate;
  final String profession;
  final String fullName;
  final String role;
  final bool isEnabled;
  final AddressModel address;

  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.birthDate,
    required this.profession,
    required this.fullName,
    required this.role,
    required this.isEnabled,
    required this.address,
  });

  /// Converte JSON -> Model (se você realmente precisar disso)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'],
      profession: json['profession'],
      fullName: json['fullName'],
      role: json['role'],
      isEnabled: json['isEnabled'],
      address: AddressModel.fromJson(json['address']),
    );
  }

  /// Converte Model -> JSON (pra API)
  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate,
      "profession": profession,
      "fullName": fullName,
      "role": role,
      "isEnabled": isEnabled,
      "address": address.toJson(),
    };
  }

  /// Converte Entity -> Model (pra enviar pra API)
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userName: entity.userName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      birthDate: entity.birthDate,
      profession: entity.profession,
      fullName: entity.fullName,
      role: entity.role,
      isEnabled: entity.isEnabled,
      address: AddressModel.fromEntity(entity.address),
    );
  }
}
