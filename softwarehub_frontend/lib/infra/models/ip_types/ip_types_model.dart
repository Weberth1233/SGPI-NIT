import '../../../domain/entities/ip_types/ip_type_entity.dart';
import 'Ip_type_structure_model.dart';

class IpTypeModel {
  final int id;
  final String name;
  final String color;
  final IpTypeStructureModel formStructure;

  IpTypeModel({
    required this.id,
    required this.name,
    required this.color,
    required this.formStructure,
  });

  factory IpTypeModel.fromJson(Map<String, dynamic> json) {
    return IpTypeModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      formStructure: IpTypeStructureModel.fromJson(json['formStructure']),
    );
  }

  factory IpTypeModel.fromEntity(IpTypeEntity entity) {
    return IpTypeModel(
      id: entity.id,
      formStructure: IpTypeStructureModel.fromEntity(entity.formStructure),
      name: entity.name, 
      color: entity.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color':color,
      'formStructure': formStructure.toJson(),
    };
  }

  /// 🔥 Model -> Entity
  IpTypeEntity toEntity() {
    return IpTypeEntity(
      id: id,
      name: name,
      color: color,
      formStructure: formStructure.toEntity(),
    );
  }
}
