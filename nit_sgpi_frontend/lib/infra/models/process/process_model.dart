import 'package:nit_sgpi_frontend/infra/models/base_model.dart';

import '../../../domain/entities/process/process_entity.dart';
import '../attachment_model.dart';
import 'process_ip_type_model.dart';
import 'process_user_model.dart';

class ProcessModel implements BaseModel{
  @override
  final int id;
  final String title;
  final String status;
  final bool isFeatured;
  final DateTime createdAt;
  final Map<String, dynamic> formData;
  final ProcessIpTypeModel ipType;
  final List<ProcessUserModel> authors;
  final List<AttachmentModel> attachments;
  final ProcessUserModel creator;

  ProcessModel({
    required this.id,
    required this.title,
    required this.status,
    required this.isFeatured,
    required this.createdAt,
    required this.formData,
    required this.ipType,
    required this.authors,
    required this.attachments,
    required this.creator,
  });

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      isFeatured: json['isFeatured'],
      createdAt: DateTime.parse(json['createdAt']),
      formData: Map<String, dynamic>.from(json['formData'] ?? {}),
      ipType: ProcessIpTypeModel.fromJson(json['ipType']),
      authors: (json['authors'] as List)
          .map((e) => ProcessUserModel.fromJson(e))
          .toList(),
      attachments: (json['attachments'] as List)
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      creator: ProcessUserModel.fromJson(json['creator']),
    );
  }

 /* factory ProcessModel.fromEntity(ProcessEntity entity) {
    return ProcessModel(
      id: entity.id,
      title: entity.title,
      status: entity.status,
      isFeatured: entity.isFeatured,
      createdAt: entity.createdAt,
      formData: entity.formData,
      ipType: IpTypeModel.fromEntity(entity.ipType),
      authors: entity.authors.map((e) => UserModel.fromEntity(e)).toList(),
      attachments: entity.attachments
          .map((e) => AttachmentModel.fromEntity(e))
          .toList(),
      creator: UserModel.fromEntity(entity.creator),
    );
  }
*/
  @override
  ProcessEntity toEntity() {
    return ProcessEntity(
      id: id,
      title: title,
      status: status,
      isFeatured: isFeatured,
      createdAt: createdAt,
      formData: formData,
      ipType: ipType.toEntity(),
      authors: authors.map((e) => e.toEntity()).toList(),
      attachments: attachments.map((e) => e.toEntity()).toList(),
      creator: creator.toEntity(),
    );
  }
}
