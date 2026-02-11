import 'package:flutter/material.dart';
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
    return SizedBox(height: 180, width: size < 1200 ? 250 :450,child: Card(color: Color(0XFF004093),child: Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 20),
      child: Column(spacing: 10,crossAxisAlignment: CrossAxisAlignment.start,children: [ 
        Text(item.title, style: context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: textColorCard.onSecondary)),
        Text(item.ipType.name, style: context.textTheme.bodySmall!.copyWith(color: textColorCard.onSecondary)), 
        Text(item.status, style: context.textTheme.bodySmall!.copyWith(color: textColorCard.onSecondary)), 
        Text(item.createdAt.toLocal().toString(), style: context.textTheme.bodySmall!.copyWith(color: textColorCard.onSecondary))],),
    ),));

  }
}