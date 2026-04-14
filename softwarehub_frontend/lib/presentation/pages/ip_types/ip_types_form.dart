import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';
import 'controllers/Ip_types_form_controller.dart';

class IpTypesForm extends GetView<IpTypesFormController> {
  const IpTypesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final secondaryStage = controller.secondStageProcess;
    final theme = Theme.of(context);


    const primaryColor = Color(0xFF094E9A);

    return Scaffold(

      backgroundColor: const Color(0xFFCBD5E1),

      // 2. AppBar padronizado (Igual a ProcessPage)
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 74,
        titleSpacing: 12,
        title: Row(
          children: [
            SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back, color: primaryColor),
                  onPressed: () => Get.back(),
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                secondaryStage.item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          // 3. Linhas de fundo no padrão sutil (preto com opacidade quase zero)
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: Colors.black.withOpacity(0.03),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Título interno do Container
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preencha as informações abaixo",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                                letterSpacing: -0.1,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Insira os dados requeridos para este tipo de processo.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // LÓGICA MANTIDA: Geração dinâmica dos campos
                        ...secondaryStage.item.formStructure.fields.map((field) {
                          final textController = controller.controllers[field.name]!;
                          final isDescription = field.name.toLowerCase().contains('descri');

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Design de input mais limpo (Flat)
                                Text(
                                  field.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  // Altura específica apenas se for caixa de descrição
                                  height: isDescription ? 150 : null,
                                  child: CustomTextField(
                                    controller: textController,
                                    label: "", // Rótulo movido para fora para maior clareza visual
                                    hintText: "Digite aqui...",
                                    keyboardType: isDescription
                                        ? TextInputType.multiline
                                        : (field.type == 'number'
                                        ? TextInputType.number
                                        : TextInputType.text),
                                    expands: isDescription,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 32),

                        // 4. Botão modernizado com Glow e mesma padronagem
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: controller.submit,
                            icon: const Icon(Icons.check_circle_outline, size: 22),
                            label: Text(
                              "ENVIAR INFORMAÇÕES",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.5), // Efeito Glow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter padronizado igual ao das outras telas
class _DiagonalLinesPainter extends CustomPainter {
  final Color color;
  _DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const spacing = 80.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}