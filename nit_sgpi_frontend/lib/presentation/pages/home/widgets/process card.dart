import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../controllers/home_controller.dart';

class ProcessCard extends StatelessWidget {
  final ProcessResponseEntity item;

  ProcessCard({super.key, required this.item});

  final ProcessController processController = Get.find<ProcessController>();

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0XFF004093);
    const contentColor = Colors.white;

    final date = item.createdAt.toLocal();
    final dateFormatted =
        "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";

    return SizedBox(
      width: 400,
      height: 190,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black26,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Get.toNamed('/home/process-detail/${item.id}');
          },
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Stack(
            children: [
              // Ícone decorativo de fundo
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.folder_copy_rounded,
                  size: 100,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),

              // BOTÃO DE DELETE
              Positioned(
                top: 10,
                right: 10,
                child: Tooltip(
                  message: "Excluir processo",
                  child: InkWell(
                    onTap: () {
                      _showDeleteDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              // Conteúdo principal
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo de IP
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            color: contentColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.ipType.name.toUpperCase(),
                          style: context.textTheme.labelSmall!.copyWith(
                            color: contentColor.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Título
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: contentColor,
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),

                    const Spacer(),

                    // Status + Data
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(item.status),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            item.status,
                            style: context.textTheme.bodySmall!.copyWith(
                              color: contentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: contentColor.withOpacity(0.7),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateFormatted,
                              style: context.textTheme.bodySmall!.copyWith(
                                color: contentColor.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DIALOG DE CONFIRMAÇÃO
  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Confirmar exclusão",
      middleText:
          "Tem certeza que deseja excluir o processo \"${item.title}\"?",
      textConfirm: "Excluir",
      textCancel: "Cancelar",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back(); // fecha o diálogo
        await processController.deleteProcess(item.id);
      },
    );
  }

  // Cor do status (pode personalizar)
  Color _getStatusColor(String status) {
    return Colors.white.withOpacity(0.15);
  }
}