class ProcessIpTypeEntity {
  final int id;
  final String name;
  final FormStructureEntity formStructure;

  ProcessIpTypeEntity({
    required this.id,
    required this.name,
    required this.formStructure,
  });
}

class FormStructureEntity {
  final List<FormFieldEntity> fields;

  FormStructureEntity({required this.fields});
}

class FormFieldEntity {
  final String name;
  final String type;
  final bool requiredField;

  FormFieldEntity({
    required this.name,
    required this.type,
    required this.requiredField,
  });
}
