import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/post_justification.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/usecases/delete_justification.dart';

class JustificationController extends GetxController {
  final PostJustification postJustification;

  JustificationController(this.postJustification);
  final TextEditingController reasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxString message = "".obs;

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  Future<void> post(int idProcess) async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value) return;

    isLoading.value = true;
    message.value = '';

    final result = await postJustification(
      JustificationRequestEntity(
        idProcess: idProcess,
        reason: reasonController.text,
      ),
    );

    result.fold(
      (Failure failure) {
        isLoading.value = false; // Para o loading em caso de erro
        message.value = failure.message;

        Get.snackbar(
          'Erro',
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition:
              SnackPosition.TOP, // Aparece embaixo para não cobrir tudo
        );
      },
      (success) async {
        // 👈 Adicione async aqui
        isLoading.value = false; // Para o loading
        message.value = success;
        reasonController.clear(); // Limpa o campo

        // 1. Mostra a mensagem
        Get.snackbar(
          'Sucesso',
          'Justificativa enviada com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        await Future.delayed(const Duration(seconds: 2));

        // Caso não tenha para onde voltar, talvez você queira ir para a Home?
        Get.offAllNamed('/home');
      },
    );
  }
}