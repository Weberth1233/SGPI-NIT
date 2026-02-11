import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_types/ip_type_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/controllers/ip_types_controller.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/process_page.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

class SecondStageProcess{
   final FirstStageProcess firstStageProcess;
   final IpTypeEntity item;

  SecondStageProcess({required this.firstStageProcess, required this.item});


}
class IpTypesPage extends StatelessWidget {
  const IpTypesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final auxProcess = Get.arguments;

    final ipTypesController = Get.find<IpTypesController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: Container(
        padding: Responsive.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Row(
              spacing: 20,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back, size: 30),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Categorias de Propriedade Intelectual",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "selecione qual o tipo de propriedade intelectual desejada!",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),

            Obx(() {
              final list = ipTypesController.ipTypes.toList();
              if (ipTypesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    "Sem resultados!",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: list
                        .map(
                          (item) => SizedBox(
                            child: InkWell(
                              onTap: () {
                               final secondStageProcess =  SecondStageProcess(firstStageProcess: auxProcess, item: item);
                                Get.toNamed(
                                  "/process/ip_types/form",
                                  arguments: secondStageProcess
                                  //arguments: item, // 👈 passa o objeto inteiro
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: Text(item.name),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
