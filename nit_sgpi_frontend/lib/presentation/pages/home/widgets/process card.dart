import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/extensions/context_extensions.dart';

import '../../../../domain/entities/process/process_entity.dart';

class ProcessCard extends StatelessWidget {
  final ProcessEntity item;
  
  const ProcessCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 150, width: 281,child: Card(color: Color(0XFF004093),child: Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 20),
      child: Column(spacing: 5,crossAxisAlignment: CrossAxisAlignment.start,children: [ Text(item.ipType.name, style: context.textTheme.bodySmall),Text(item.title, style: context.textTheme.bodySmall), Text(item.status, style: Theme.of(context).textTheme.bodySmall), Text(item.createdAt.toLocal().toString(), style: Theme.of(context).textTheme.bodySmall)],),
    ),));

  }
}