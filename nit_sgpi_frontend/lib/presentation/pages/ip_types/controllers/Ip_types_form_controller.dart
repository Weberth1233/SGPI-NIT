import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/ip_types/ip_type_entity.dart';

class IpTypesFormController extends GetxController {
  final IpTypeEntity ipType;

  IpTypesFormController(this.ipType);

  final Map<String, TextEditingController> controllers = {};

  @override
  void onInit() {
    super.onInit();
    for (final field in ipType.formStructure.fields) {
      controllers[field.name] = TextEditingController();
    }
  }

  @override
  void onClose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  bool validate() {
    for (final field in ipType.formStructure.fields) {
      if (field.requiredField) {
        final value = controllers[field.name]?.text ?? '';
        if (value.trim().isEmpty) {
          Get.snackbar('Erro', 'O campo "${field.name}" é obrigatório');
          return false;
        }
      }
    }
    return true;
  }

  void submit() {
    if (!validate()) return;

    final Map<String, dynamic> result = {};

    controllers.forEach((key, controller) {
      result[key] = controller.text;
    });

    // Aqui você pode mandar pra API
    print(result);
    Get.snackbar('Sucesso', 'Formulário enviado com sucesso!');
  }
}
