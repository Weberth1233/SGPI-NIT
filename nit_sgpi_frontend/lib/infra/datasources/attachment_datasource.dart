// 1. Novos imports
import 'dart:convert';

import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/attachment_model.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop'; // Necessário para .toJS

import 'package:flutter/foundation.dart'; // kIsWeb
// Remova o dart:html
// import 'dart:html' as html; 

import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';

abstract class IAttachmentDatasource {
  Future<void> openDocument(int id);
  Future<List<AttachmentEntity>> getAttachments(int idProcess);
}

class AttachmentDataSourceImpl implements IAttachmentDatasource {
  final ApiClient apiClient;

  AttachmentDataSourceImpl(this.apiClient);

  @override
  Future<void> openDocument(int id) async {
    // Verificação de segurança: Se não for Web, retornamos ou lançamos erro
    // pois web.window não existe no Android/iOS.
    if (!kIsWeb) {
      throw Exception("O download via Blob só é suportado na Web.");
    }

    final response = await apiClient.get(
      "${BaseUrl.urlWithHttp}/attachments/download/template/$id",
    );

    // ... código anterior (apiClient.get) ...

    if (response.statusCode != 200) {
      throw Exception("Erro ao abrir documento");
    }

   // ... validações e response ...

    // 1. Criar o Blob (PDF)
    final blob = web.Blob(
      [response.bodyBytes.toJS].toJS, 
      web.BlobPropertyBag(type: 'application/pdf'),
    );

    // 2. Criar a URL do objeto
    final blobUrl = web.URL.createObjectURL(blob);

    // 3. Criar um elemento <a> (link) temporário
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = blobUrl;
    anchor.download = 'meu_documento.pdf'; // Nome do arquivo que será salvo
    anchor.style.display = 'none'; // Esconde o elemento (opcional, mas boa prática)

    // 4. Adicionar ao corpo da página, clicar e remover
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();

    // 5. Limpar memória após o download iniciar
    Future.delayed(const Duration(seconds: 2), () {
      web.URL.revokeObjectURL(blobUrl);
    });
  }
  
  @override
  Future<List<AttachmentEntity>> getAttachments(int idProcess) async{
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/attachments/process/$idProcess",
      );

      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body) as List;

        return decoded
            .map(
              (e) =>
                  AttachmentModel.fromJson(e as Map<String, dynamic>).toEntity(),
            )
            .toList();
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}