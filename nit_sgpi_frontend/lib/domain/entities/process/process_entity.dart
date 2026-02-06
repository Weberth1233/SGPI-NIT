import 'package:nit_sgpi_frontend/domain/entities/process/ip_type_entity.dart';

import 'attachment_entity.dart';
import 'user_entity.dart';

class ProcessEntity {
  final int id;
  final String title;
  final String status;
  final bool isFeatured;
  final DateTime createdAt;
  final Map<String, dynamic> formData;
  final IpTypeEntity ipType;
  final List<UserEntity> authors;
  final List<AttachmentEntity> attachments;
  final UserEntity creator;

  ProcessEntity({
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
}
