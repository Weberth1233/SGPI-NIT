import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import '../core/errors/failures.dart';

abstract class IAttachmentRepository {
  Future<Either<Failure, void>> openDocument(int id, {bool signed = false});
  Future<Either<Failure, List<AttachmentEntity>>> getAttachments(int idProcess);
  Future<Either<Failure, String>> uploadDocument( {required int id, 
    String? filePath,       // Para Mobile
    Uint8List? fileBytes,   // Para Web
    required String fileName}); // Obrigatório para Web);
}