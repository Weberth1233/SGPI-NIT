import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../datasources/auth_local_datasource.dart';

class ApiClient {
  final http.Client client;
  final AuthLocalDataSource local;

  ApiClient(this.client, this.local);

  Future<Map<String, String>> _headers() async {
    final token = await local.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> get(String url) async {
    return client.get(
      Uri.parse(url),
      headers: await _headers(),
    );
  }

  Future<http.Response> post(String url, {Object? body}) async {
    return client.post(
      Uri.parse(url),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
  }
Future<http.Response> upload(
    String url, {
    String? filePath,       // Caminho (Para Mobile)
    List<int>? fileBytes,   // Bytes (Para Web)
    required String fileName, // Nome do arquivo é obrigatório na Web
    String fieldName = 'file',
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Headers de Auth
    final token = await local.getToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    http.MultipartFile multipartFile;

    // Lógica Híbrida (Web vs Mobile)
    if (kIsWeb) {
      // --- MODO WEB ---
      // Na web, o path é inútil/falso, precisamos dos bytes
      if (fileBytes == null) throw Exception("Na Web, os bytes do arquivo são obrigatórios");
      
      multipartFile = http.MultipartFile.fromBytes(
        fieldName,
        fileBytes,
        filename: fileName,
      );
    } else {
      // --- MODO MOBILE (Android/iOS) ---
      // No mobile, usar path é melhor para memória
      if (filePath == null) throw Exception("No Mobile, o path é obrigatório");

      multipartFile = await http.MultipartFile.fromPath(
        fieldName,
        filePath,
        filename: fileName,
      );
    }

    request.files.add(multipartFile);

    final streamedResponse = await client.send(request);
    return await http.Response.fromStream(streamedResponse);
  }
}