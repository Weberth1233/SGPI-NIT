import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/widgets/process%20card.dart';

import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_menu.dart';

import 'controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final processController = Get.find<ProcessController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.onSecondary,
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
                  // ===== Header: título + botão
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add, size: 25),
                            SizedBox(width: 3),
                            Text(
                              "CADASTRAR PROCESSO",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== Cards de status (resumo)
                  Align(
                    alignment: Alignment.center, // Alinha os cards à esquerda
                    child: Obx(() {
                      if (processController.isLoadingProcessCount.value) {
                        return const CircularProgressIndicator();
                      }
                      if (processController.processesStatus.isEmpty) {
                        return const Text("Nenhum dado encontrado");
                      }

                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: processController.processesStatus.map((item) {
                          return SizedBox(
                            height: 120,
                            width: 280,
                            child: Card(
                              elevation: 4,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.2,
                                  ),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.status.toUpperCase(),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors
                                            .grey[700], // Cinza escuro para melhor leitura no branco
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.amount.toString(),
                                      style: theme.textTheme.bodyLarge!.copyWith(
                                        color: Colors
                                            .black87, // Preto suave para o número
                                        fontWeight: FontWeight.w900,
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

                  const SizedBox(height: 12),

                  // ===== Bloco cinza: filtros + search (seu exemplo)
                  const FilterHeader(),

                  const SizedBox(height: 20),

                  // ===== Lista de processos
                  Obx(() {
                    final list = processController.processes.toList();

                    if (processController.isLoading.value) {
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
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: list
                              .map((item) => ProcessCard(item: item))
                              .toList(),
                        ),

                        const SizedBox(height: 14),

                        Obx(() {
                          final isLoadingMore =
                              processController.isLoading.value;

                          return ElevatedButton(
                            onPressed: isLoadingMore
                                ? null
                                : () => processController.fetchProcesses(
                                    loadMore: true,
                                  ),
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
    "Finalizado",
    "Tramitado",
    "Correção",
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
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _title(context),
                const SizedBox(height: 12),
                _buildFilters(context),
                const SizedBox(height: 12),
                _buildSearch(context, controller),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title(context),
                      const SizedBox(height: 12),
                      _buildFilters(context),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(width: 250, child: _buildSearch(context, controller)),
              ],
            ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Processos",
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Filtre pelo status do seu processo",
          style: context.textTheme.bodySmall!.copyWith(
            color: Colors.black.withOpacity(0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: 0,
        runSpacing: 0,
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          final isFirst = index == 0;
          final isLast = index == filters.length - 1;

          BorderRadius radius;
          if (isFirst) {
            radius = const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            );
          } else if (isLast) {
            radius = const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            );
          } else {
            radius = BorderRadius.zero;
          }

          return InkWell(
            onTap: () {
              setState(() => selectedIndex = index);

              final statusMap = {
                0: "",
                1: "FINALIZADO",
                2: "TRAMITADO",
                3: "CORRECAO",
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
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Pesquisar...",
        prefixIcon: Icon(
          Icons.search,
          size: 25,
          color: Colors.black.withOpacity(0.55),
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) => processController.searchByTitle(value),
    );
  }
}
