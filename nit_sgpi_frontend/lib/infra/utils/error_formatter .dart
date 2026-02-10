import 'dart:convert';

class ApiErrorFormatter {
  static String formatFromBody(String body) {
    final Map<String, dynamic> json = jsonDecode(body);

    final List erros = json['erros'];

    final buffer = StringBuffer();
    buffer.writeln(json['mensagem'] ?? "Erro");
    buffer.writeln();

    for (var e in erros) {
      final campo = _traduzirCampo(e['campo']?.toString() ?? "Campo");
      final mensagem = _humanizarMensagem(e['erro']?.toString() ?? "Erro inválido");

      buffer.writeln("• $campo: $mensagem");
    }

    return buffer.toString();
  }

  /// Traduz só os campos conhecidos, o resto deixa como veio
  static String _traduzirCampo(String campo) {
    const mapa = {
      "userName": "Usuário",
      "password": "Senha",
      "phoneNumber": "Telefone",
      "fullName": "Nome completo",
      "email": "E-mail",
    };

    return mapa[campo] ?? campo;
  }

  /// Não depende de texto exato, só melhora a leitura
  static String _humanizarMensagem(String msg) {
    var m = msg.trim();

    // Primeira letra maiúscula
    if (m.isNotEmpty) {
      m = m[0].toUpperCase() + m.substring(1);
    }

    // Remove ponto final duplicado etc, se quiser
    return m;
  }
}
