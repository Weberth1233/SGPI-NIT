class IpTypeEntity {
  final int id;
  final String name;
  final IpTypeStructureEntity formStructure;

  IpTypeEntity({
    required this.id,
    required this.name,
    required this.formStructure,
  });
}

class IpTypeStructureEntity {
  final List<IpTypeFieldEntity> fields;

  IpTypeStructureEntity({
    required this.fields,
  });
}

class IpTypeFieldEntity {
  final String name;
  final String type;
  final bool requiredField;

  IpTypeFieldEntity({
    required this.name,
    required this.type,
    required this.requiredField,
  });
}
