import '../../../../domain/entities/paged_result_entity.dart';
import '../../../../domain/entities/process/process_entity.dart';
import 'process_model.dart';

class PagedProcessResultModel {
  final List<ProcessModel> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final bool first;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;

  PagedProcessResultModel({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.first,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.empty,
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

  /// 👇 Model -> Entity
  PagedResultEntity<ProcessEntity> toEntity() {
    return PagedResultEntity<ProcessEntity>(
      content: content.map((e) => e.toEntity()).toList(),
      totalPages: totalPages,
      totalElements: totalElements,
      last: last,
      first: first,
      size: size,
      number: number,
      numberOfElements: numberOfElements,
      empty: empty,
    );
  }
}
