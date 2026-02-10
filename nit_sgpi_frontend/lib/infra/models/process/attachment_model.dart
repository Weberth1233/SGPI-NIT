import 'package:nit_sgpi_frontend/domain/entities/process/attachment_entity.dart';

class AttachmentModel {
  final int id;
  final String displayName;
  final String status;
  final String templateFilePath;
  final String signedFilePath;

  AttachmentModel({
    required this.id,
    required this.displayName,
    required this.status,
    required this.templateFilePath,
    required this.signedFilePath,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      displayName: json['displayName'],
      status: json['status'],
      templateFilePath: json['templateFilePath'],
      signedFilePath: json['signedFilePath'],
    );
  }

  factory AttachmentModel.fromEntity(AttachmentEntity entity) {
    return AttachmentModel(
      id: entity.id,
      displayName: entity.displayName,
      status: entity.status,
      templateFilePath: entity.templateFilePath,
      signedFilePath: entity.signedFilePath,
    );
  }

  AttachmentEntity toEntity() {
    return AttachmentEntity(
      id: id,
      displayName: displayName,
      signedFilePath: signedFilePath,
      status: status,
      templateFilePath: templateFilePath
    );
  }


}
