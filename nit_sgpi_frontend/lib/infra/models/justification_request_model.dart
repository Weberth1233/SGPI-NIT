import 'package:nit_sgpi_frontend/domain/entities/justification_request_entity.dart';

class JustificationRequestModel {
  final int processId;
  final String reason;

  JustificationRequestModel({required this.processId, required this.reason});


/*   factory JustificationRequestModel.fromJson(Map<String, dynamic> json) {
    return JustificationRequestModel(
      idProcess: json['idProcess'],
      reason: json['reason']
    );
  }*/

  Map<String, dynamic> toJson() {
    return {
      'processId': processId,
      'reason': reason,
    };
  }

  factory JustificationRequestModel.fromEntity(JustificationRequestEntity entity) {
    return JustificationRequestModel(
      processId: entity.idProcess,
      reason: entity.reason
    );
  }

  JustificationRequestEntity toEntity() {
    return JustificationRequestEntity(
      idProcess: processId,
      reason: reason
    );
  }
}