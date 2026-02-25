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

    // Cores base
    const backgroundColor = Color(0xFF094E9A);
    // Uma cor ligeiramente mais clara para as linhas do fundo
    final backgroundLineColor = Colors.white.withOpacity(0.05);
    const surfaceColor = Colors.white;

    // Estilo de sombra reutilizável para os cards brancos
    final commonShadow = BoxShadow(
      color: Colors.black.withOpacity(0.2), // Sombra escura suave
      blurRadius: 16, // Desfoque alto para suavidade
      offset: const Offset(0, 8), // Deslocamento vertical
      spreadRadius: 0,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      // Usamos um Stack para colocar o padrão de linhas atrás do conteúdo
      body: Stack(
        children: [
          // CAMADA 1: Pintura das linhas de fundo
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundLinesPainter(color: backgroundLineColor),
            ),
          ),

          // CAMADA 2: Conteúdo Principal com AppBar flutuante
          SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    children: [
                      // Botão de voltar quadrado, MAIOR e com SOMBRA
                      Container(
                        height: 52, // Aumentado
                        width: 52, // Aumentado
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [commonShadow], // Sombra adicionada
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: backgroundColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        secondaryStage.item.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: surfaceColor,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                // Corpo rolável
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Container com SOMBRA
                            Center(
                              child: Container(
                                height: 50,
                                width: 600,
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    commonShadow,
                                  ], // Sombra adicionada
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Preencha as informações abaixo",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: backgroundColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Mapeamento dos Campos
                            ...secondaryStage.item.formStructure.fields.map((
                              field,
                            ) {
                              final textController =
                                  controller.controllers[field.name]!;

                              final isDescription = field.name
                                  .toLowerCase()
                                  .contains('descri');

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Container(
                                  width: 800,
                                  // ✅ Aumentamos a altura do card da descrição para 240
                                  height: isDescription ? 240 : 120,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [commonShadow],
                                  ),
                                  child: CustomTextField(
                                    controller: textController,
                                    label: field.name,
                                    keyboardType: isDescription
                                        ? TextInputType.multiline
                                        : (field.type == 'number'
                                              ? TextInputType.number
                                              : TextInputType.text),

                                    // ✅ Magia acontecendo aqui: manda o input preencher o card!
                                    expands: isDescription,
                                  ),
                                ),
                              );
                            }).toList(),

                            const SizedBox(height: 32),

                            // Botão de Enviar com Elevação
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: controller.submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: surfaceColor,
                                    foregroundColor: backgroundColor,
                                    elevation:
                                        8, // Elevação aumentada para destaque
                                    shadowColor: Colors.black.withOpacity(0.4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Text(
                                    'Enviar Informações',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32), // Espaço extra no final
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundLinesPainter extends CustomPainter {
  final Color color;
  _BackgroundLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth =
          1.0 // Espessura da linha
      ..style = PaintingStyle.stroke;

    const spacing = 60.0; // Espaçamento entre as linhas

    // Desenha linhas diagonais da esquerda para a direita
    for (double i = -size.height; i < size.width; i += spacing) {
      // Offset inicial ( topo, ajustado por i) -> Offset final (base, ajustado por i + altura)
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height * 0.7, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
