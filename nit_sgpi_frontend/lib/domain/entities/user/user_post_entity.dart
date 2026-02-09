import 'address_entity.dart';

abstract class UserPostEntity {
  String get userName;
  String get email;
  String get password;
  String get phoneNumber;
  String get birthDate; // pode ser DateTime se preferir
  String get profession;
  String get fullName;
  String get role;
  bool get isEnabled;
  AddressEntity get address;
}
