import '../../domain/entities/paged_result_entity.dart';
import 'process/process_model.dart';

class PagedProcessResultModel extends PagedResultEntity<ProcessModel> {
  PagedProcessResultModel({
    required super.content,
    required super.totalPages,
    required super.totalElements,
    required super.last,
    required super.first,
    required super.size,
    required super.number,
    required super.numberOfElements,
    required super.empty,
  });

  factory PagedProcessResultModel.fromJson(Map<String, dynamic> json) {
    return PagedProcessResultModel(
      content: (json['content'] as List)
          .map((e) => ProcessModel.fromJson(e))
          .toList(),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      last: json['last'],
      first: json['first'],
      size: json['size'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      empty: json['empty'],
    );
  }
}
