import '../../../domain/entities/process/process_ip_type_entity.dart';

class ProcessIpTypeModel {
  final int id;
  final String name;
  final String color;
  final FormStructureEntity formStructure;

  ProcessIpTypeModel({
    required this.id,
    required this.name,
    required this.color,
    required this.formStructure,
  });

  factory ProcessIpTypeModel.fromJson(Map<String, dynamic> json) {
    return ProcessIpTypeModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      formStructure: FormStructureModel.fromJson(json['formStructure']),
    );
  }

  factory ProcessIpTypeModel.fromEntity(ProcessIpTypeEntity entity) {
    return ProcessIpTypeModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      formStructure: entity.formStructure,
    );
  }

  ProcessIpTypeEntity toEntity() {
    return ProcessIpTypeEntity(id: id, name: name,color: color, formStructure: formStructure);
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
