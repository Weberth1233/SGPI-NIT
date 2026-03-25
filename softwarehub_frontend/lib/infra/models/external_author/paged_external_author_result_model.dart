import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/external_author/external_author_model.dart';
import '../../../domain/entities/paged_result_entity.dart';

class PagedExternalAuthorResultModel {
  final List<ExternalAuthorModel> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final bool first;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;

  PagedExternalAuthorResultModel({
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

  factory PagedExternalAuthorResultModel.fromJson(Map<String, dynamic> json) {
    return PagedExternalAuthorResultModel(
      content: (json['content'] as List)
          .map((e) => ExternalAuthorModel.fromJson(e))
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
  PagedResultEntity<ExternalAuthorEntity> toEntity() {
    return PagedResultEntity<ExternalAuthorEntity>(
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