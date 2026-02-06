
import '../../../domain/entities/process/attachment_entity.dart';

class AttachmentModel extends AttachmentEntity {
  AttachmentModel({
    required super.id,
    required super.displayName,
    required super.status,
    required super.templateFilePath,
    required super.signedFilePath,
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
}
