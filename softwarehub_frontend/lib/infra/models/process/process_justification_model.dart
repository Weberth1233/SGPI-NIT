import 'package:nit_sgpi_frontend/domain/entities/process/process_justification_entity.dart';

class ProcessJustificationModel {
  final int id;
  final String reason;
  final String createdAt;

  ProcessJustificationModel({required this.id, required this.reason, required this.createdAt});


  factory ProcessJustificationModel.fromJson(Map<String, dynamic> json) {
    return ProcessJustificationModel(
      id: json['id'],
      reason: json['reason'],
      createdAt: json['createdAt']
    );
  }

  factory ProcessJustificationModel.fromEntity(ProcessJustificationEntity entity) {
    return ProcessJustificationModel(
      id: entity.id,
      reason: entity.reason,
      createdAt: entity.createdAt,
    );
  }

  ProcessJustificationEntity toEntity() {
    return ProcessJustificationEntity(
      id: id,
      reason: reason,
      createdAt: createdAt,
    );
  }

}