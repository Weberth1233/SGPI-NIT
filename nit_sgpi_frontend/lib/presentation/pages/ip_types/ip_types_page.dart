import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_types/ip_type_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/controllers/ip_types_controller.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/process_page.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

class SecondStageProcess {
  final FirstStageProcess firstStageProcess;
  final IpTypeEntity item;
  final bool isEdit;
  final String? originalIpTypeId;
  final Map<String, dynamic>? originalFormData;

  SecondStageProcess({
    required this.firstStageProcess,
    required this.item,
    this.isEdit = false,
    this.originalIpTypeId,
    this.originalFormData,
  });
}

class IpTypesPage extends StatelessWidget {
  const IpTypesPage({super.key});

  static const Color _backgroundColor = Color(0xFF004294);

  @override
  Widget build(BuildContext context) {
    final auxProcess = Get.arguments as FirstStageProcess;
    final ipTypesController = Get.find<IpTypesController>();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _Header(
                title: "Categoria de propriedade intelectual",
                subtitle: "Selecione o tipo de propriedade intelectual",
                onBack: Get.back,
              ),
              const SizedBox(height: 80),

              Expanded(
                child: Obx(() {
                  if (ipTypesController.isLoading.value) {
                    return const _LoadingState();
                  }

                  final list = ipTypesController.ipTypes.toList();
                  if (list.isEmpty) {
                    return const _EmptyState(
                      title: "Sem resultados",
                      message: "Nenhuma categoria disponível no momento.",
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;

                      // Grid responsiva
                      final int columns = w >= 1100
                          ? 4
                          : w >= 840
                          ? 3
                          : w >=
                                600 // Ajuste leve no breakpoint
                          ? 2
                          : 1;

                      return Scrollbar(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 600,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.touch_app_rounded,
                                        size: 20,
                                        color: _backgroundColor.withOpacity(
                                          0.8,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          "Escolha e clique em uma categoria para avançar.",
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: _backgroundColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              _ResponsiveGrid(
                                columns: columns,
                                gap: 20,
                                children: list.map((item) {
                                  return _IpTypeCard(
                                    title: item.name,
                                    dominantColor: _backgroundColor,
                                    onTap: () {
                                      final secondStageProcess = SecondStageProcess(
                                        firstStageProcess: auxProcess,
                                        item: item,
                                        isEdit: auxProcess.isEdit,
                                        originalIpTypeId:
                                            auxProcess.originalIpTypeId,
                                        originalFormData:
                                            auxProcess.originalFormData,
                                      );

                                      Get.toNamed(
                                        "/process/ip_types/form",
                                        arguments: secondStageProcess,
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------------------ UI pieces ------------------------------ */

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onBack,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 24,
                color: Color(0XFF004093),
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Carregando categorias...",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const _EmptyState({required this.title, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.saved_search_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: IpTypesPage._backgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Tentar novamente"),
            ),
          ],
        ],
      ),
    );
  }
}

class _IpTypeCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color dominantColor;

  const _IpTypeCard({
    required this.title,
    required this.onTap,
    required this.dominantColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const double borderRadiusValue = 24.0;

    return Container(
      // Margem vertical pequena para garantir que a sombra não seja cortada por outros elementos
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: [
          BoxShadow(
            color: dominantColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8), // Deslocamento vertical para baixo
            spreadRadius: -2, // Faz a sombra parecer "sair" de baixo do card
          ),
        ],
      ),
      // Material é usado aqui apenas para cortar o efeito de "splash" do InkWell nas bordas arredondadas
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          // Cores de feedback ao toque ajustadas para combinar
          splashColor: dominantColor.withOpacity(0.08),
          highlightColor: dominantColor.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // --- Contêiner do ícone ---
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    // Fundo azul bem clarinho
                    color: dominantColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.psychology_outlined, // Ícone de cérebro
                    color: dominantColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 18),

                // --- Título ---
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3748),
                      fontSize: 16.5,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color.fromARGB(
                    255,
                    7,
                    84,
                    228,
                  ), // Cinza claro e sutil
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid simples sem depender de package.
class _ResponsiveGrid extends StatelessWidget {
  final int columns;
  final double gap;
  final List<Widget> children;

  const _ResponsiveGrid({
    required this.columns,
    required this.gap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) SizedBox(height: gap),
          ],
        ],
      );
    }

    final rows = (children.length / columns).ceil();

    return Column(
      children: List.generate(rows, (r) {
        final start = r * columns;
        final end = (start + columns).clamp(0, children.length);
        final rowItems = children.sublist(start, end);

        return Padding(
          padding: EdgeInsets.only(bottom: r == rows - 1 ? 0 : gap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(columns, (c) {
              final idx = start + c;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: c == columns - 1 ? 0 : gap),
                  child: idx < children.length
                      ? rowItems[c]
                      : const SizedBox.shrink(),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
