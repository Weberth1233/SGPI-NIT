import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

import 'controllers/attachments_controller.dart';

class AttachmentsPage extends StatefulWidget {
  const AttachmentsPage({super.key});

  @override
  State<AttachmentsPage> createState() => _AttachmentsPageState();
}

class _AttachmentsPageState extends State<AttachmentsPage> {
  final int processId = Get.arguments is int ? Get.arguments : 0;
  final controller = Get.find<AttachmentController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (processId != 0) {
        controller.attachments(processId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Documentos do Processo"),
        backgroundColor: theme.colorScheme.primary,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: Responsive.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da Lista
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Anexos Necessários",
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            
            Expanded(
              child: Obx(() {
                if (controller.attachmentList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_off_outlined, size: 64, color: theme.colorScheme.outline),
                        const SizedBox(height: 16),
                        Text("Nenhum documento encontrado.", style: textTheme.bodyLarge),
                      ],
                    ),
                  );
                }
      
                // 3. Lista de Documentos
                return ListView.separated(
                  itemCount: controller.attachmentList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final entity = controller.attachmentList[index];
                    return _buildAttachmentCard(context, entity);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentCard(BuildContext context, AttachmentEntity entity) {
    final theme = Theme.of(context);
    final bool isSigned = entity.signedFilePath != "" && entity.signedFilePath != null;

    // Cores fixas para o visual desejado (Fundo Azul Escuro, Texto Branco)
    final cardBackgroundColor = theme.colorScheme.primary; // Assume que sua cor primária é o azul escuro do tema
    const textColor = Colors.white;
    final secondaryTextColor = Colors.white.withOpacity(0.7);
    const iconBackgroundColor = Color(0xFF4A6583); // Um azul mais claro para o fundo do ícone
    const statusColor = Color(0xFF2ECC71); // Verde para SIGNED/Upload realizado

    return Card(
      elevation: 4,
      color: cardBackgroundColor, // Define a cor de fundo do Card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bordas mais arredondadas
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha superior: Ícone + Nome + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: iconBackgroundColor, // Fundo circular azul mais claro
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.description, color: textColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.displayName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor, // Texto branco
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Modelo: ${entity.templateFilePath}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                           color: secondaryTextColor, // Texto branco secundário
                           overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSigned) _buildStatusChip(context, entity.status, statusColor),
              ],
            ),
            
            const SizedBox(height: 20),
            Divider(height: 1, color: Colors.white.withOpacity(0.2)), // Divisor branco sutil
            const SizedBox(height: 20),

            // Linha inferior: Ações e Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Arquivo Assinado:",
                        style: theme.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            isSigned ? "Upload realizado" : "Pendente de envio",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isSigned ? statusColor : textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isSigned) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.check_circle, color: statusColor, size: 18),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Ações
                Row(
                  children: [
                    IconButton(
                      tooltip: "Baixar Modelo",
                      icon: const Icon(Icons.download_rounded, color: textColor),
                      onPressed: () {
                        controller.open(entity.id);
                         // Ação para baixar modelo
                         // controller.downloadTemplate(entity.id);
                      },
                    ),
                    const SizedBox(width: 8),
                     entity.status == "SIGNED" ? IconButton(
                      tooltip: "Baixar Documento assinado",
                      icon: const Icon(Icons.download_rounded, color: textColor),
                      onPressed: () {
                        controller.open(entity.id,signed: true);
                         // Ação para baixar modelo
                         // controller.downloadTemplate(entity.id);
                      },
                    ): SizedBox(),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        controller.pickAndUpload(attachmentId: entity.id);
                      },
                      icon: Icon(isSigned ? Icons.edit : Icons.upload_file, color: textColor),
                      label: Text(isSigned ? "Alterar" : "Enviar", style: const TextStyle(color: textColor)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: textColor), // Borda branca
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color, // Cor de fundo do chip (verde)
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white, // Texto branco
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}