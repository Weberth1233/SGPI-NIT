import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/justifications/controllers/justification_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';

class JustificationPage extends GetView<JustificationController> {
  const JustificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final idProcess = Get.arguments as int;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Justificativa do processo"),
        backgroundColor: colors.primary,
        foregroundColor: colors.onSecondary,
        elevation: 0,
      ),
      backgroundColor: colors.onSecondary,
      body: SingleChildScrollView( // Adicionado para evitar overflow de teclado
        child: Container(
          margin: Responsive.getPadding(context),
          // Envolvemos num Form para validar
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Estica o botão
              children: [
                const SizedBox(height: 90),
                CustomTextField(
                  controller: controller.reasonController, // Usa o controller do GetX
                  label: "Justificativa",
                  maxLines: 15,
                  // maxLines: 15,
                  keyboardType: TextInputType.multiline,
                  // Validação simples
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira uma justificativa.';
                    }
                    if (value.length < 10) {
                      return 'A justificativa deve ter pelo menos 10 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                // Obx escuta as mudanças de estado (isLoading)
                Obx(() {
                  return SizedBox(
                    height: 50, // Altura padrão boa para botões touch
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null // Desabilita o botão visualmente
                          : () => controller.post(idProcess),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary, // Garante cor visível
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Enviar",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}