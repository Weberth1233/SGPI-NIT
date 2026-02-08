// data/models/process_status_count_model.dart

import '../../../domain/entities/process/process_status_count_entity.dart';
class ProcessStatusCountModel extends ProcessStatusCountEntity {
  
  ProcessStatusCountModel({
    required super.status,
    required super.amount,
  });

  factory ProcessStatusCountModel.fromJson(Map<String, dynamic> json) {
    return ProcessStatusCountModel(
      status: json['status'] as String,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'amount': amount,
    };
  }
}
