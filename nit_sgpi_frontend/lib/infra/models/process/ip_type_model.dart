import '../../../domain/entities/process/ip_type_entity.dart';

class IpTypeModel {
  final int id;
  final String name;
  final FormStructureEntity formStructure;

  IpTypeModel({
    required this.id,
    required this.name,
    required this.formStructure,
  });

  factory IpTypeModel.fromJson(Map<String, dynamic> json) {
    return IpTypeModel(
      id: json['id'],
      name: json['name'],
      formStructure: FormStructureModel.fromJson(json['formStructure']),
    );
  }

  factory IpTypeModel.fromEntity(IpTypeEntity entity) {
    return IpTypeModel(
      id: entity.id,
      name: entity.name,
      formStructure: entity.formStructure,
    );
  }

  IpTypeEntity toEntity() {
    return IpTypeEntity(id: id, name: name, formStructure: formStructure);
  }
}

class FormStructureModel extends FormStructureEntity {
  FormStructureModel({required super.fields});

  factory FormStructureModel.fromJson(Map<String, dynamic> json) {
    return FormStructureModel(
      fields: (json['fields'] as List)
          .map((e) => FormFieldModel.fromJson(e))
          .toList(),
    );
  }
}

class FormFieldModel extends FormFieldEntity {
  FormFieldModel({
    required super.name,
    required super.type,
    required super.requiredField,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      name: json['name'],
      type: json['type'],
      requiredField: json['required'],
    );
  }
}
