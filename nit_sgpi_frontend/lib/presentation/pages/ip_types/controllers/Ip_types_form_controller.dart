import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_request_entity.dart';
// Certifique-se de importar o SecondStageProcess corretamente aqui
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/ip_types_page.dart';
import '../../process/controllers/process_post_controller.dart'
    show ProcessPostController;

class IpTypesFormController extends GetxController {
  final SecondStageProcess secondStageProcess;

  IpTypesFormController(this.secondStageProcess);

  final Map<String, TextEditingController> controllers = {};

  @override
  void onInit() {
    super.onInit();

    final isSameIpType =
        secondStageProcess.isEdit &&
        secondStageProcess.item.id.toString() ==
            secondStageProcess.originalIpTypeId;
    for (final field in secondStageProcess.item.formStructure.fields) {
      String initialValue = '';
      if (isSameIpType && secondStageProcess.originalFormData != null) {
        initialValue =
            secondStageProcess.originalFormData![field.name]?.toString() ?? '';
      }
      controllers[field.name] = TextEditingController(text: initialValue);
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
    for (final field in secondStageProcess.item.formStructure.fields) {
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

  void clearForm() {
    for (final c in controllers.values) {
      c.clear();
    }
  }

  Future<void> submit() async {
    if (!validate()) return;

    // ... [Seu código de submissão continua igual aqui] ...
    final processController = Get.find<ProcessPostController>();
    final Map<String, dynamic> result = {};

    controllers.forEach((key, controller) {
      result[key] = controller.text;
    });

    try {
      if (secondStageProcess.isEdit &&
          secondStageProcess.firstStageProcess.idProcess != null) {
        await processController.put(
          secondStageProcess.firstStageProcess.idProcess!,
          ProcessRequestEntity(
            title: secondStageProcess.firstStageProcess.title,
            ipTypeId: secondStageProcess.item.id,
            isFeatured: true,
            authorIds: secondStageProcess.firstStageProcess.idsUser,
            formData: result,
          ),
        );
      } else {
        await processController.post(
          ProcessRequestEntity(
            title: secondStageProcess.firstStageProcess.title,
            ipTypeId: secondStageProcess.item.id,
            isFeatured: true,
            authorIds: secondStageProcess.firstStageProcess.idsUser,
            formData: result,
          ),
        );
      }
      Get.snackbar('Sucesso', 'Processo enviado com sucesso!');
      clearForm();
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao enviar processo');
    }
  }
}
