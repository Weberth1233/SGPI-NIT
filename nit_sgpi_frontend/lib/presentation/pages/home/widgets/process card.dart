import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nit_sgpi_frontend/presentation/shared/extensions/context_extensions.dart'; // Mantive sua extensão
import 'package:intl/intl.dart'; // Recomendo adicionar o pacote intl para formatar datas

import '../../../../domain/entities/process/process_response_entity.dart';

class ProcessCard extends StatelessWidget {
  final ProcessResponseEntity item;

  const ProcessCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0XFF004093);
    const contentColor = Colors.white;

    final date = item.createdAt.toLocal();
    final dateFormatted =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    return SizedBox(
      width: 400,
      height: 190,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black26,
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior:
            Clip.antiAlias, // Garante que o efeito de clique respeite a borda
        child: InkWell(
          onTap: () {
            Get.toNamed('/home/process-detail/${item.id}');
          },
          // Efeito de clique sutil na cor branca
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Stack(
            children: [
              // Decoração de Fundo (Ícone grande e transparente)
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.folder_copy_rounded,
                  size: 100,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),

              // Conteúdo Principal
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Cabeçalho: Tipo e Ícone ---
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

                    // --- Título Principal ---
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow
                          .ellipsis, // Evita quebra de layout se o texto for grande
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: contentColor,
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),

                    const Spacer(), // Empurra o conteúdo abaixo para o fundo do card
                    // --- Rodapé: Status e Data ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badge de Status
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

                        // Data
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

  // Função auxiliar para dar uma cor diferente ao fundo do status se você quiser
  // (No momento está retornando transparente com opacidade, mas pode ser condicional)
  Color _getStatusColor(String status) {
    // Exemplo: se status for "CONCLUIDO" retorna verde transparente
    // return status == "CONCLUIDO" ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.1);
    return Colors.white.withOpacity(0.15);
  }
}
