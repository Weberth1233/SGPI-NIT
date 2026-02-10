import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/widgets/process card.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_menu.dart';

import 'controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final processController = Get.find<ProcessController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: CustomMenu(
        child: SingleChildScrollView(
          child: Container(
            padding: Responsive.getPadding(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Meus Processos",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Novo processo", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Obx(() {
                      if (processController.isLoadingProcessCount.value) {
                        return const CircularProgressIndicator();
                      }
                      if (processController.processesStatus.isEmpty) {
                        return const Text("Nenhum dado encontrado");
                      }
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: processController.processesStatus.map((item) {
                          return SizedBox(
                            height: 120,
                            width: 280,
                            child: Card(
                              color: Theme.of(context).colorScheme.onSecondary,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.status, // 👈 vem da API
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.amount.toString(), // 👈 vem da API
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                      
                  Text(
                    "Processos",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Filtre pelo status do seu processo",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const FilterHeader(),
                  const SizedBox(height: 20),
                      
                  /// 👇 Só essa parte é reativa
                  Obx(() {
                    final list = processController.processes.toList();
                    if (processController.isLoading.value) {
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
                                (item) =>
                                    SizedBox(child: ProcessCard(item: item)),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 20,),
                        Obx(() {
                          final isLoadingMore = processController.isLoading.value;
                      
                          return ElevatedButton(
                            onPressed: isLoadingMore
                                ? null
                                : () {
                                    processController.fetchProcesses(
                                      loadMore: true,
                                    );
                                  },
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Ver mais",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.
                                           onSecondary,
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
        ),
      ),
    );
  }
}

class FilterHeader extends StatefulWidget {
  const FilterHeader({super.key});

  @override
  State<FilterHeader> createState() => _FilterHeaderState();
}

class _FilterHeaderState extends State<FilterHeader> {
  final List<String> filters = [
    "Ver todos",
    "Em andamento",
    "Correção",
    "Finalizado",
  ];
  int selectedIndex = 0;

  final TextEditingController controller = TextEditingController();
  final processController = Get.find<ProcessController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFilters(context),
                    const SizedBox(height: 12),
                    _buildSearch(controller),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildFilters(context)),
                    const SizedBox(width: 16),
                    SizedBox(width: 300, child: _buildSearch(controller)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 8,
      children: List.generate(filters.length, (index) {
        final isSelected = selectedIndex == index;
        final isFirst = index == 0;
        final isLast = index == filters.length - 1;

        BorderRadius radius;
        if (isFirst) {
          radius = const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          );
        } else if (isLast) {
          radius = const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          );
        } else {
          radius = BorderRadius.zero;
        }

        return InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });

            final statusMap = {
              0: "",
              1: "EM_ANDAMENTO",
              2: "CORRECAO",
              3: "FINALIZADO",
            };

            processController.filterByStatus(statusMap[index]!);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
              borderRadius: radius,
            ),
            child: Text(
              filters[index],
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearch(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.tertiary,
      ),
      decoration: InputDecoration(
        hintText: "Pesquisar...",
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        prefixIcon: const Icon(Icons.search, size: 22),
        alignLabelWithHint: true,
        isDense: true,
      ),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) {
        processController.searchByTitle(value);
      },
    );
  }
}
