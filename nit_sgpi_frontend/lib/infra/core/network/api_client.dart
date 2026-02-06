import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../datasources/auth_local_datasource.dart';

class ApiClient {
  final AuthLocalDataSource local;

  ApiClient(this.local);

  Future<Map<String, String>> _headers() async {
    final token = await local.getToken();

    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> get(String url) async {
    return http.get(Uri.parse(url), headers: await _headers());
  }

  Future<http.Response> post(String url, {Object? body}) async {
    return http.post(
      Uri.parse(url),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
  }
}
