import 'dart:convert';
import 'dart:typed_data'; // Necessário para Uint8List

// Imports condicionais e de pacotes
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:web/web.dart' as web; // O substituto do dart:html
import 'dart:js_interop'; // Necessário para converter bytes para JS

// Seus imports do projeto
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/attachment_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';

abstract class IAttachmentDatasource {
  Future<void> openDocument(int id);
  Future<List<AttachmentEntity>> getAttachments(int idProcess);
  
  // MUDANÇA IMPORTANTE:
  // Removemos 'File file' (que é do dart:io) e trocamos por parâmetros agnósticos
  Future<String> uploadDocument({
    required int id, 
    String? filePath,       // Para Mobile
    Uint8List? fileBytes,   // Para Web
    required String fileName // Obrigatório para Web
  });
}

class AttachmentDataSourceImpl implements IAttachmentDatasource {
  final ApiClient apiClient;

  AttachmentDataSourceImpl(this.apiClient);

  @override
  Future<void> openDocument(int id) async {
    // URL do endpoint de download
    final url = "${BaseUrl.urlWithHttp}/attachments/download/template/$id";

    // 1. Faz a requisição para pegar os bytes do PDF
    final response = await apiClient.get(url);

    if (response.statusCode != 200) {
      throw ServerException("Erro ao baixar documento: ${response.statusCode}");
    }

    // 2. Lógica Específica para WEB
    if (kIsWeb) {
      try {
        // Converte os bytes do Dart (Uint8List) para um formato que o JS entenda
        final arrayBuffer = response.bodyBytes.toJS;
        
        // Cria o Blob (arquivo em memória no navegador)
        final blob = web.Blob(
          [arrayBuffer].toJS, 
          web.BlobPropertyBag(type: 'application/pdf')
        );

        // Cria uma URL temporária para esse Blob
        final blobUrl = web.URL.createObjectURL(blob);

        // Cria um elemento <a> invisível no DOM
        final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
        anchor.href = blobUrl;
        anchor.download = 'documento_sgpi_$id.pdf'; // Nome sugerido para salvar
        anchor.style.display = 'none';

        // Adiciona ao corpo, clica e remove
        web.document.body?.append(anchor);
        anchor.click();
        anchor.remove();

        // Limpa a memória da URL criada
        // Usamos Future.delayed para garantir que o download iniciou antes de revogar
        Future.delayed(const Duration(seconds: 2), () {
          web.URL.revokeObjectURL(blobUrl);
        });

      } catch (e) {
        throw Exception("Erro ao processar download na Web: $e");
      }
    } else {
      // TODO: Implementar lógica Mobile (open_file ou url_launcher)
      // No mobile, você geralmente salva os bytes em um arquivo temporário (path_provider)
      // e usa o pacote open_file para abrir.
      throw UnimplementedError("Visualização direta no Mobile ainda não implementada neste trecho.");
    }
  }

  @override
  Future<List<AttachmentEntity>> getAttachments(int idProcess) async {
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/attachments/process/$idProcess",
      );

      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body) as List;

        return decoded
            .map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList();
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar anexos! - Detalhes: ${response.body}',
        );
      }
    } catch (e) {
      // Se não for ServerException, assume erro de rede
      if (e is ServerException) rethrow;
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  @override
  Future<String> uploadDocument({
    required int id, 
    String? filePath, 
    Uint8List? fileBytes, 
    required String fileName
  }) async {
    try {
      // Chama o método .upload do seu ApiClient (que criamos no passo anterior)
      // Note que passamos os parâmetros opcionais
      final response = await apiClient.upload(
        "${BaseUrl.urlWithHttp}/attachments/upload/$id",
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
        fieldName: 'file', // Nome do campo no backend
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao enviar arquivo! - Detalhes: ${response.body}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Erro de conexão ao tentar enviar o arquivo.');
    }
  }
}