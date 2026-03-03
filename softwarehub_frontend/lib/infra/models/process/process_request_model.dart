import 'package:nit_sgpi_frontend/domain/entities/process/process_request_entity.dart';

class ProcessRequestModel {
  final String title;
  final int ipTypeId;
  final bool isFeatured;
  final List<int> authorIds;
  final Map<String, dynamic> formData;

  ProcessRequestModel({
    required this.title,
    required this.ipTypeId,
    required this.isFeatured,
    required this.authorIds,
    required this.formData,
  });

  factory ProcessRequestModel.fromJson(Map<String, dynamic> json) {
    return ProcessRequestModel(
      title: json['title'] as String,
      ipTypeId: json['ipTypeId'] as int,
      isFeatured: json['isFeatured'] as bool,
      authorIds: List<int>.from(json['authorIds'] as List),
      formData: Map<String, dynamic>.from(json['formData'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ipTypeId': ipTypeId,
      'isFeatured': isFeatured,
      'authorIds': authorIds,
      'formData': formData,
    };
  }

  factory ProcessRequestModel.fromEntity(ProcessRequestEntity entity) {
    return ProcessRequestModel(
      title: entity.title,
      ipTypeId: entity.ipTypeId,
      isFeatured: entity.isFeatured,
      authorIds: entity.authorIds,
      formData: entity.formData,
    );
  }
  
  ProcessRequestEntity toEntity() {
    return ProcessRequestEntity(
      title: title,
      authorIds: authorIds,
      formData: formData,
      ipTypeId: ipTypeId,
      isFeatured: isFeatured,
    );
  }
}
