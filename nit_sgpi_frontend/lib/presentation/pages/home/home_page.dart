import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/widgets/process card.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

import 'controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final processController = Get.find<ProcessController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: Container(
        padding: Responsive.getPadding(context),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 71),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Meus Processos",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 20),
                 Center(
                  child: Wrap(spacing: 10,runSpacing: 10, children: [
                    SizedBox(height:120,width: 280, child: Card(color: Theme.of(context).colorScheme.onSecondary,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text("EM andamento", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                        Text("01", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                      ],)
                    ),)),
                    SizedBox(height:120,width: 280, child: Card(color: Theme.of(context).colorScheme.onSecondary,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text("CORREÇÃO", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                        Text("01", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                      ],)
                    ),)),SizedBox(height:120,width: 280, child: Card(color: Theme.of(context).colorScheme.onSecondary,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text("FINALIZADO", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                        Text("01", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                      ],)
                    ),)),
                  ],),
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
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: list
                        .map((item) => SizedBox(child: ProcessCard(item: item)))
                        .toList(),
                  );
                }),
              ],
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
