import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_user_controller.dart';

import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';

// first stage of the process
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
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    titlecontroller.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<ProcessUserController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 74,
        titleSpacing: 12,
        title: Row(
          children: [
            SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onSecondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: colors.primary),
                  onPressed: () => Get.back(),
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cadastro de Processo",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: colors.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: colors.onSecondary.withOpacity(0.04),
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Responsive.getPadding(context).left,
              20,
              Responsive.getPadding(context).right,
              24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.onSecondary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 1050;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "CADASTRE SEU PROCESSO",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colors.tertiary,
                              letterSpacing: -0.3,
                            ),
                          ),

                          Text(
                            "Inserir as informações necessárias para cadastrar seu processo no sistema",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.tertiary.withOpacity(0.75),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ===== Linha: Título do processo
                          _LabeledFieldRow(
                            label: "Título do processo :",
                            field: CustomTextField(
                              controller: titlecontroller,
                              label: "",
                              hintText: "",
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ===== Linha: Pesquisa de membros
                          _LabeledFieldRow(
                            label: "Membros :",
                            field: CustomTextField(
                              controller: searchController,
                              label: "",
                              hintText: "Pesquisar Membros...",
                              onFieldSubmitted: (_) => userController
                                  .searchByFullName(searchController.text),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // ===== Conteúdo principal (grade + painel selecionados)
                          Obx(() {
                            final list = userController.users.toList();

                            if (userController.isLoading.value) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (list.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Text(
                                    "Sem resultados!",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.error,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // selecionados (com base na lista atual)
                            final selectedUsers = list.where((u) {
                              final id = _safeId(u);
                              return id != null &&
                                  userController.selectedUserIds.contains(id);
                            }).toList();

                            if (!isDesktop) {
                              // Mobile: painel selecionados fica abaixo
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _MembersGrid(
                                    users: list,
                                    selectedIds: userController.selectedUserIds,
                                    onToggle: (id) =>
                                        userController.toggleUser(id),
                                  ),
                                  const SizedBox(height: 16),
                                  _SelectedMembersPanel(
                                    title: "Membros Selecionados :",
                                    selectedUsers: selectedUsers,
                                    selectedIdsCount:
                                        userController.selectedUserIds.length,
                                    onRemove: (id) =>
                                        userController.toggleUser(id),
                                  ),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _MembersGrid(
                                    users: list,
                                    selectedIds: userController.selectedUserIds,
                                    onToggle: (id) =>
                                        userController.toggleUser(id),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                SizedBox(
                                  width: 300,
                                  child: _SelectedMembersPanel(
                                    title: "Membros Selecionados :",
                                    selectedUsers: selectedUsers,
                                    selectedIdsCount:
                                        userController.selectedUserIds.length,
                                    onRemove: (id) =>
                                        userController.toggleUser(id),
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 26),

                          // ===== Botão central "Próximo"
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 220,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (titlecontroller.text == "" ||
                                      userController.selectedUserIds
                                          .toList()
                                          .isEmpty) {
                                    Get.snackbar(
                                      "Campos inválidos!",
                                      "Necessário inserir os campos abaixo para prosseguir com o cadastro do processo!",
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      colorText: colors.onSecondary,
                                    );
                                  } else {
                                    final auxProcess = FirstStageProcess(
                                      title: titlecontroller.text,
                                      idsUser: userController.selectedUserIds
                                          .toList(),
                                    );
                                    Get.toNamed(
                                      "/process/ip_types",
                                      arguments: auxProcess,
                                    );
                                    titlecontroller.clear();
                                    userController.selectedUserIds.clear();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Próximo",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSecondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// Widgets UI (somente design)
// =====================

class _LabeledFieldRow extends StatelessWidget {
  final String label;
  final Widget field;

  const _LabeledFieldRow({required this.label, required this.field});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 760;

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.tertiary,
                ),
              ),
              const SizedBox(height: 10),
              field,
            ],
          );
        }

        return Row(
          children: [
            SizedBox(
              width: 180,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.tertiary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: field),
          ],
        );
      },
    );
  }
}

class _MembersGrid extends StatelessWidget {
  final List<dynamic> users;
  final Set<int> selectedIds;
  final void Function(int id) onToggle;

  const _MembersGrid({
    required this.users,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        int cols = 2;
        if (w >= 1100)
          cols = 4;
        else if (w >= 820)
          cols = 3;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 2.25, //  (card retangular)
          ),
          itemBuilder: (context, index) {
            final u = users[index];
            final id = _safeId(u);
            final selected = id != null && selectedIds.contains(id);

            final fullName = _safeString(() => u.fullName, fallback: "Nome");
            final email = _safeString(() => u.email, fallback: "Email");

            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: id == null ? null : () => onToggle(id),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? Colors.white.withOpacity(0.85)
                        : Colors.white.withOpacity(0.12),
                    width: selected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // avatar tipo mock
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: colors.primary.withOpacity(0.7),
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _WhiteInfoPill(text: fullName, strong: true),
                          const SizedBox(height: 8),
                          _WhiteInfoPill(text: email, strong: false),
                        ],
                      ),
                    ),

                    if (selected) ...[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.check_circle,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _WhiteInfoPill extends StatelessWidget {
  final String text;
  final bool strong;
  const _WhiteInfoPill({required this.text, required this.strong});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors.tertiary,
          fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}

class _SelectedMembersPanel extends StatelessWidget {
  final String title;
  final List<dynamic> selectedUsers;
  final int selectedIdsCount;
  final void Function(int id) onRemove;

  const _SelectedMembersPanel({
    required this.title,
    required this.selectedUsers,
    required this.selectedIdsCount,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 420,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),

          if (selectedIdsCount == 0)
            Expanded(
              child: Center(
                child: Text(
                  "Nenhum selecionado",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSecondary.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: selectedUsers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final u = selectedUsers[i];
                  final id = _safeId(u);

                  final name = _safeString(() => u.fullName, fallback: "Nome");

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.tertiary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (id != null)
                          IconButton(
                            tooltip: "Remover",
                            visualDensity: VisualDensity.compact,
                            onPressed: () => onRemove(id),
                            icon: Icon(
                              Icons.close,
                              size: 18,
                              color: colors.primary.withOpacity(0.85),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// =====================
// Helpers seguros
// =====================

int? _safeId(dynamic u) {
  try {
    final v = u.id;
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  } catch (_) {
    return null;
  }
}

String _safeString(String Function() getter, {required String fallback}) {
  try {
    final v = getter();
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  } catch (_) {
    return fallback;
  }
}

// =====================
// Background painter
// =====================

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;
  _DiagonalLinesPainter({required this.color});

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
