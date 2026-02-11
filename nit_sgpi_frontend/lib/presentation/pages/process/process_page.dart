import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_user_controller.dart';

import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';

class ProcessPage extends StatelessWidget {
  const ProcessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<ProcessUserController>();

    TextEditingController controller = TextEditingController();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: theme.colorScheme.onSecondary,
      body: SingleChildScrollView(
        child: Container(
          padding: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 90),
              Text("Cadastro de Processo", style: theme.textTheme.headlineMedium),
              Text(
                "Insirar as informações necessárias para cadastrar seu processo no sistema",
              ),
              SizedBox(height: 90),
              CustomTextField(
                controller: controller,
                label: "Titulo do Processo",
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Text("Selecione os membros")),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add, size: 25),
                    ),
                  ),
                ],
              ),
              Obx(() {
                final list = userController.users.toList();
        
                if (userController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
        
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "Sem resultados!",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  );
                }
        
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      spacing: 20,
        
                      children: list.map((item) {
                        return Obx(() {
                          print(item.id);
                          final isChecked = userController.selectedUserIds
                              .contains(item.id);
        
                          return CheckboxListTile(
                            title: Text(item.fullName, style: Theme.of(context).textTheme.bodySmall,),
                            value: isChecked,
                            onChanged: (value) {
                              userController.toggleUser(item.id!);
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, // checkbox na esquerda
                          );
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Obx(() {
                      final isLoadingMore = userController.isLoading.value;
        
                      return ElevatedButton(
                        onPressed: isLoadingMore
                            ? null
                            : () => userController.fetchUsers(loadMore: true),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: isLoadingMore
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                "Ver mais",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
