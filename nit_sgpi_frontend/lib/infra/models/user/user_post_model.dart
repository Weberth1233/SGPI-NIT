

import 'package:nit_sgpi_frontend/infra/models/user/address_model.dart';

import '../../../domain/entities/user/address_entity.dart';
import '../../../domain/entities/user/user_post_entity.dart';

class UserPostModel extends UserPostEntity {
  @override
  final String userName;
  @override
  final String email;
  @override
  final String password;
  @override
  final String phoneNumber;
  @override
  final String birthDate;
  @override
  final String profession;
  @override
  final String fullName;
  @override
  final String role;
  @override
  final bool isEnabled;
  @override
  final AddressEntity address;

  UserPostModel({
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

  factory UserPostModel.fromJson(Map<String, dynamic> json) {
    return UserPostModel(
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
      "address": (address as AddressModel).toJson(),
    };
  }
}
