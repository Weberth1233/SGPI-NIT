import 'address_entity.dart';

class UserEntity {
  final String userName;
  final String email;
  final String password;
  final String phoneNumber;
  final String birthDate;
  final String profession;
  final String fullName;
  final String role;
  final bool isEnabled;
  final AddressEntity address;

  UserEntity({
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
}
