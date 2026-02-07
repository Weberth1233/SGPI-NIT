import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/widgets/process%20card.dart';

import 'controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final processController = Get.find<ProcessController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(title: const Text('Processos')),
      body: Obx(() {
        if (processController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (processController.errorMessage.isNotEmpty) {
          return Center(child: Text(processController.errorMessage.value));
        }

        final list = processController.processes;

        if (list.isEmpty) {
          return const Center(child: Text('Nenhum processo encontrado'));
        }

        return Wrap(
          children: list
              .map(
                (item) =>
                    SizedBox(child: ProcessCard(item: item)),
              )
              .toList(),
        );
      }),
    );
  }
}
