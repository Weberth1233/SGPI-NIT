import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/widgets/process%20card.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/infra/datasources/auth_local_datasource.dart';
import 'controllers/home_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final processController = Get.find<ProcessController>();
  final authLocalDataSource = Get.find<AuthLocalDataSource>();

  /*{
  "email": "marialurdes1234@gmail.com",
  "password": "marialurdes123"
}*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: AppBar(
              // O fundo do AppBar fica transparente para mostrar o Container branco
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.primary,
              // Removemos a elevação padrão para usar a sombra customizada do Container
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 90,
              // Mantém o formato no AppBar para o 'ripple effect' (clique) respeitar a borda
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              // Reduzi um pouco o espaçamento para compensar o arredondamento da pílula
              titleSpacing: 24,
              title: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/logo_sgpi.svg",
                    width: 60,
                    height: 65,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome ",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w300,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.6,
                                  ),
                                  letterSpacing: -0.5,
                                ),
                              ),

                              TextSpan(
                                text: "Software",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.9,
                                  ),
                                  letterSpacing: -0.5,
                                ),
                              ),

                              TextSpan(
                                text: "Hub",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 30,
                                  color: Color(0xFFFDAA51),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              actions: [
                FutureBuilder<String?>(
                  future: authLocalDataSource.getRole(),
                  builder: (context, snapshot) {
                    final isAdmin = snapshot.data == 'ADMIN';

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      // Respiro lateral um pouco maior
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // Mantém os itens agrupados
                        children: [
                          // 1. Badge de Permissão (Tag)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical:
                                  4, // Mais horizontal, menos vertical = formato de pílula perfeito
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(
                                0.08,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.2,
                                ), // Borda sutil dá um ar sofisticado
                                width: 1,
                              ),
                            ),
                            child: Text(
                              isAdmin ? "ADMIN" : "USUÁRIO",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 0.5, //
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          IconButton(
                            onPressed: () {
                              Get.toNamed("/user-logged");
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(40, 40),
                            ),
                            icon: const Icon(Icons.person, size: 45),
                          ),

                          // --- NOVA BARRA DIVISÓRIA AQUI ---
                          const SizedBox(width: 18.5), // Espaço antes da barra

                          Container(
                            height: 70,
                            width: 1.6,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          const SizedBox(width: 13), // Espaço depois da barra
                          // 3. Botão de Sair
                          TextButton.icon(
                            onPressed: () {
                              authLocalDataSource.clear();
                              Get.offAllNamed("/login");
                            },
                            icon: Icon(
                              Icons.logout_rounded,
                              color: theme.colorScheme.primary,
                              size: 36,
                            ),
                            label: Text(
                              "Sair",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 19,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalLinesPainter(
                color: theme.colorScheme.onSecondary.withOpacity(0.04),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: Responsive.getPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
          
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Painel de Processos",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: theme.colorScheme.onTertiary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "Sistema de Gestão de Propriedade Intelectual",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 17,
                                color: theme.colorScheme.onTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed("/process");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.onTertiary,
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, size: 22),
                            const SizedBox(width: 6),
                            Text(
                              "NOVO PROCESSO",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 32),
          
                  Align(
                    alignment: Alignment.bottomLeft,
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
                          return Container(
                            height: 55,
                            width: 260,
                            padding: const EdgeInsets.only(left: 20, right: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.status,
                                    style: const TextStyle(
                                      decorationColor: ThemeColor.greyColor,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFDAA51),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.amount.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
          
                  const SizedBox(height: 32),
          
                  // --- AQUI COMEÇA A CAIXA CINZA ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onTertiaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FilterHeader(),
                        const SizedBox(height: 24),
                        Obx(() {
                          final list = processController.processes.toList();
          
                          if (processController.isLoadingList.value) {
                            return const Center(child: CircularProgressIndicator());
                          }
          
                          if (list.isEmpty) {
                            return Center(
                              child: Text(
                                "Sem resultados!",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            );
                          }
          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  children: list
                                      .map((item) => ProcessCard(item: item))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Obx(() {
                                final isLoadingMore =
                                    processController.isLoadingMore.value;
          
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
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.onSecondary,
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
          
                  const SizedBox(height: 32),
          
                  const SizedBox(height: 20),
          
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
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
    final isMobile = MediaQuery.of(context).size.width < 700;

    return SizedBox(
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
                SizedBox(width: 280, child: _buildSearch(context, controller)),
              ],
            ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visão Geral",
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Filtre pelo status do seu processo",
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 14,
            color: Colors.black87,
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
            borderRadius: radius,
            onTap: () {
              setState(() => selectedIndex = index);

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
                  fontSize: 15,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
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
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: "Pesquisar...",
        hintStyle: const TextStyle(fontSize: 16),
        prefixIcon: Icon(
          Icons.search,
          size: 20,
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

class DiagonalLinesPainter extends CustomPainter {
  final Color color;
  DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 80.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}