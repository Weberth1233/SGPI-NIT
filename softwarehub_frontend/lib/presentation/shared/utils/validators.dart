import 'package:get/get.dart';

class Validators {
  static String? required(String? value, {String message = "Campo obrigatório"}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Informe o e-mail";
    }
    if (!GetUtils.isEmail(value)) {
      return "E-mail inválido";
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? message}) {
    if (value == null || value.length < min) {
      return message ?? "Deve ter pelo menos $min caracteres";
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Informe o telefone";
    }
    final onlyNumbers = value.replaceAll(RegExp(r'\D'), '');
    if (onlyNumbers.length < 10) {
      return "Telefone inválido";
    }
    return null;
  }

  static String? cep(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Informe o CEP";
    }
    final onlyNumbers = value.replaceAll(RegExp(r'\D'), '');
    if (onlyNumbers.length != 8) {
      return "CEP inválido";
    }
    return null;
  }
}
