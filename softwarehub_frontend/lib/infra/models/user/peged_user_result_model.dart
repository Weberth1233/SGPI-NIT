import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_model.dart';

import '../../../../domain/entities/paged_result_entity.dart';

class PagedUserResultModel {
  final List<UserModel> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final bool first;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;

  PagedUserResultModel({
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

  factory PagedUserResultModel.fromJson(Map<String, dynamic> json) {
    return PagedUserResultModel(
      content: (json['content'] as List)
          .map((e) => UserModel.fromJson(e))
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
  PagedResultEntity<UserEntity> toEntity() {
    return PagedResultEntity<UserEntity>(
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
