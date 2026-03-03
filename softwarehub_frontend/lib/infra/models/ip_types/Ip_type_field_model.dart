import '../../../domain/entities/ip_types/ip_type_entity.dart';

class IpTypeFieldModel {
  final String name;
  final String type;
  final bool requiredField;

  IpTypeFieldModel({
    required this.name,
    required this.type,
    required this.requiredField,
  });

  factory IpTypeFieldModel.fromJson(Map<String, dynamic> json) {
    return IpTypeFieldModel(
      name: json['name'],
      type: json['type'],
      requiredField: json['required'],
    );
  }

  factory IpTypeFieldModel.fromEntity(IpTypeFieldEntity entity) {
    return IpTypeFieldModel(
      name: entity.name,
      requiredField: entity.requiredField,
      type: entity.type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'required': requiredField,
    };
  }

  IpTypeFieldEntity toEntity() {
    return IpTypeFieldEntity(
      name: name,
      type: type,
      requiredField: requiredField,
    );
  }
}
