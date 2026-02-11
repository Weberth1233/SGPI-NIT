import '../../../domain/entities/ip_types/ip_type_entity.dart';
import 'Ip_type_field_model.dart';

class IpTypeStructureModel {
  final List<IpTypeFieldModel> fields;

  IpTypeStructureModel({
    required this.fields,
  });

  factory IpTypeStructureModel.fromJson(Map<String, dynamic> json) {
    return IpTypeStructureModel(
      fields: (json['fields'] as List)
          .map((e) => IpTypeFieldModel.fromJson(e))
          .toList(),
    );
  }

  factory IpTypeStructureModel.fromEntity(IpTypeStructureEntity entity) {
    return IpTypeStructureModel(
      fields: entity.fields.map((e) => IpTypeFieldModel.fromEntity(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fields': fields.map((e) => e.toJson()).toList(),
    };
  }

  IpTypeStructureEntity toEntity() {
    return IpTypeStructureEntity(
      fields: fields.map((e) => e.toEntity()).toList(),
    );
  }
}
