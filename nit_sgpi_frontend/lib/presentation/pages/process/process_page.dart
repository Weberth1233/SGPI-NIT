import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_user_controller.dart';

import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';

//first stage of the process
class FirstStageProcess {
  final String title;
  final List<int> idsUser;

  FirstStageProcess({required this.title, required this.idsUser});
}

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titlecontroller.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<ProcessUserController>();

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
              Text(
                "Cadastro de Processo",
                style: theme.textTheme.headlineMedium,
              ),
              Text(
                "Insirar as informações necessárias para cadastrar seu processo no sistema",
              ),
              SizedBox(height: 90),
              CustomTextField(
                controller: titlecontroller,
                label: "Titulo do Processo",
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(flex: 2, child: Text("Selecione os membros")),
                  Expanded(
                    child: CustomTextField(
                      controller: searchController,
                      label: "Pesquisar",
                      onFieldSubmitted: (_) => userController.searchByFullName(
                        searchController.text,
                      ),
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
                          final isChecked = userController.selectedUserIds
                              .contains(item.id);

                          return CheckboxListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(
                                  item.fullName,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),

                                Text(
                                  item.email,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                

                              ],
                            ),
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
                    ElevatedButton(
                      onPressed: () {
                        if (titlecontroller.text == "" ||
                            userController.selectedUserIds.toList().isEmpty) {
                          Get.snackbar(
                            "Campos inválidos!",
                            "Necessário inserir os campos abaixo para prosseguir com o cadastro do processo!",
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          );
                        } else {
                    
                          final auxProcess = FirstStageProcess(
                            title: titlecontroller.text,
                            idsUser: userController.selectedUserIds.toList(),
                          );
                          Get.toNamed(
                            "/process/ip_types",
                            arguments: auxProcess,
                          );
                          titlecontroller.clear();
                          userController.selectedUserIds.clear();
                        }
                      },
                      child: Text(
                        "Proximo",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                    /*Obx(() {
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
                    }),*/
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
