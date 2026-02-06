import '../../../domain/entities/process/ip_type_entity.dart';

class IpTypeModel extends IpTypeEntity {
  IpTypeModel({
    required super.id,
    required super.name,
    required super.formStructure,
  });

  factory IpTypeModel.fromJson(Map<String, dynamic> json) {
    return IpTypeModel(
      id: json['id'],
      name: json['name'],
      formStructure: FormStructureModel.fromJson(json['formStructure']),
    );
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
