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
        elevation: 0,
        backgroundColor: colors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: colors.primary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Justificativa",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: colors.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: colors.onSecondary.withOpacity(0.04),
              ),
            ),
          ),

          // Scroll para teclado e telas menores
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Responsive.getPadding(context).left,
              20,
              Responsive.getPadding(context).right,
              24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.onSecondary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Correção / Justificativa",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colors.tertiary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Explique o motivo da correção para o processo #$idProcess.",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.secondary,
                          ),
                        ),
                        const SizedBox(height: 18),

                        CustomTextField(
                          controller: controller.reasonController,
                          label: "Justificativa",
                          maxLines: 12,
                          keyboardType: TextInputType.multiline,
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

                        const SizedBox(height: 18),

                        Obx(() {
                          return SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.post(idProcess),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                disabledBackgroundColor: colors.primary
                                    .withOpacity(0.55),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
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
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                            color: colors.onSecondary,
                                            fontWeight: FontWeight.w800,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;
  _DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

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
