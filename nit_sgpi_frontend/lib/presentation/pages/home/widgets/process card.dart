import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:nit_sgpi_frontend/presentation/shared/extensions/context_extensions.dart';

import '../../../../domain/entities/process/process_response_entity.dart';

class ProcessCard extends StatelessWidget {
  final ProcessResponseEntity item;
  //Teste token 222
  const ProcessCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size.width;

    final textColorCard = Theme.of(context).colorScheme;

return MouseRegion(
  cursor: SystemMouseCursors.click,
  child: InkWell(
    onTap: (){
      Get.toNamed("/home/detail", arguments: item);
    },
    child: SizedBox(
      height: 180,
      width: size < 1200 ? 250 : 450,
      child: Card(
        color: const Color(0XFF004093),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColorCard.onSecondary,
                  fontSize: 18, // <-- Altere aqui o tamanho do título
                ),
              ),
              Text(
                item.ipType.name,
                style: context.textTheme.bodySmall!.copyWith(
                  color: textColorCard.onSecondary,
                  fontSize: 14, // <-- Altere aqui o tamanho do tipo
                ),
              ),
              Text(
                item.status,
                style: context.textTheme.bodySmall!.copyWith(
                  color: textColorCard.onSecondary,
                  fontSize: 14, // <-- Altere aqui o tamanho do status
                ),
              ),
              Text(
                item.createdAt.toLocal().toString(),
                style: context.textTheme.bodySmall!.copyWith(
                  color: textColorCard.onSecondary,
                  fontSize: 12, // <-- Altere aqui o tamanho da data
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);

  }
}