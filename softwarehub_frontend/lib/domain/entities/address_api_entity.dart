// ENTITY
class AddressApiEntity {
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

  const AddressApiEntity({
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
}