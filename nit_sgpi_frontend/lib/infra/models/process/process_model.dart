import '../../../domain/entities/process/process_entity.dart';
import 'attachment_model.dart';
import 'ip_type_model.dart';
import 'user_model.dart';

class ProcessModel extends ProcessEntity {
  ProcessModel({
    required super.id,
    required super.title,
    required super.status,
    required super.isFeatured,
    required super.createdAt,
    required super.formData,
    required super.ipType,
    required super.authors,
    required super.attachments,
    required super.creator,
  });

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      isFeatured: json['isFeatured'],
      createdAt: DateTime.parse(json['createdAt']),
      formData: Map<String, dynamic>.from(json['formData'] ?? {}),
      ipType: IpTypeModel.fromJson(json['ipType']),
      authors: (json['authors'] as List)
          .map((e) => UserModel.fromJson(e))
          .toList(),
      attachments: (json['attachments'] as List)
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      creator: UserModel.fromJson(json['creator']),
    );
  }
}
