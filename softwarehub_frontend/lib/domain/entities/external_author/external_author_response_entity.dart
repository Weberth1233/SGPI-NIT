import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';

class ExternalAuthorResponseEntity extends ExternalAuthorEntity {
  final int id;
  ExternalAuthorResponseEntity({required this.id, required super.fullName, required super.email, required super.cpf});
}