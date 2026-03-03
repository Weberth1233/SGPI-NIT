import '../../../domain/entities/process/process_user_entity.dart';

class ProcessUserModel {
  final int id;
  final String fullName;
  final String email;

  ProcessUserModel({required this.id, required this.fullName, required this.email});

  factory ProcessUserModel.fromJson(Map<String, dynamic> json) {
    return ProcessUserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }

  factory ProcessUserModel.fromEntity(ProcessUserEntity entity) {
    return ProcessUserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
    );
  }

  ProcessUserEntity toEntity() {
    return ProcessUserEntity(
      id: id,
      email: email,
      fullName: fullName,
    );
  }

}
