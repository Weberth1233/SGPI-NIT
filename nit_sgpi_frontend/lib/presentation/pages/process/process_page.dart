import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_user_controller.dart';
import '../../../domain/entities/process/process_response_entity.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';

class FirstStageProcess {
  final int? idProcess;
  final String title;
  final List<int> idsUser;
  final bool isEdit;
  final String? originalIpTypeId;
  final Map<String, dynamic>? originalFormData;

  FirstStageProcess({this.idProcess,required this.title, required this.idsUser, this.isEdit = false, this.originalIpTypeId,
    this.originalFormData,});
}

class ProcessPage extends StatefulWidget {
  final bool isEditMode;
  
  const ProcessPage({super.key, this.isEditMode = false,});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {

final ProcessResponseEntity? process = Get.arguments is ProcessResponseEntity ? Get.arguments : null;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final userController = Get.find<ProcessUserController>();
  Worker? _usersWorker;

  @override
  void initState() {
    super.initState();
    if (process != null) {
      titleController.text = process!.title;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userController = Get.find<ProcessUserController>();
        final Set<int> pendingIds = process!.authors
                .map((u) => u.id)
                .whereType<int>()
                .toSet();
        _usersWorker = ever(userController.users, (List<UserEntity> loadedUsers) {
          if (pendingIds.isEmpty) return;
          for (var user in loadedUsers) {
            if (pendingIds.contains(user.id)) {
              userController.selectedUsers[user.id!] = user;
                            pendingIds.remove(user.id); 
            }
          }
        });
        if (userController.users.isEmpty) {
          userController.fetchUsers();
        }
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    searchController.dispose();
    _usersWorker?.dispose(); 
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
              child: Text(
                widget.isEditMode ? "Editar do Processo" :"Cadastro de Processo",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
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
                            widget.isEditMode ? "Editar seu Processo" : "Cadastre seu Processo",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colors.primary,
                              letterSpacing: -0.1,
                              fontSize: 35,
                            ),
                          ),
                          Text(
                           widget.isEditMode ?"Inserir as informações necessárias para atualizar seu processo no sistema": "Inserir as informações necessárias para cadastrar seu processo no sistema",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.tertiary.withOpacity(0.75),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),

                          _LabeledFieldRow(
                            label: "Título do processo :",
                            field: CustomTextField(
                              controller: titleController,
                              label: "",
                              hintText: "",
                            ),
                          ),

                          const SizedBox(height: 18),

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
                          Obx(() {
                            if (userController.isLoading.value &&
                                userController.users.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (userController.errorMessage.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  userController.errorMessage.value,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }

                            final list = userController.users.toList();
                            final selectedUsersList = userController
                                .selectedUsers
                                .values
                                .toList();

                            final Widget grid = list.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Text(
                                        "Sem resultados!",
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: theme.colorScheme.error,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  )
                                : _MembersGrid(
                                    users: list,
                                    selectedUsersMap:
                                        userController.selectedUsers,
                                    onToggle: userController.toggleUser,
                                  );

                            // 3. Botões de Paginação (Anterior e Próxima)
                            final Widget paginationButtons =
                                userController.errorMessage.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Botão Anterior
                                        OutlinedButton(
                                          onPressed:
                                              userController.isLoading.value ||
                                                  userController.page.value == 0
                                              ? null
                                              : () => userController
                                                    .fetchPreviousPage(),
                                          child: const Text("Anterior"),
                                        ),

                                        const SizedBox(width: 24),

                                        // Indicador de página (ajuda o usuário a saber onde está)
                                        Text(
                                          "Página ${userController.page.value + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(width: 24),

                                        // Botão Próxima
                                        OutlinedButton(
                                          onPressed:
                                              userController.isLoading.value ||
                                                  !userController.hasMore.value
                                              ? null
                                              : () => userController.fetchUsers(
                                                  loadMore: true,
                                                ),
                                          child: const Text("Próxima"),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink();

                            if (!isDesktop) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  grid,
                                  const SizedBox(height: 12),
                                  paginationButtons,
                                  const SizedBox(height: 16),
                                  _SelectedMembersPanel(
                                    title: "Membros Selecionados :",
                                    selectedUsers: selectedUsersList,
                                    selectedIdsCount:
                                        userController.selectedUsers.length,
                                    onRemove: userController.removeUserById,
                                  ),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      grid,
                                      const SizedBox(height: 12),
                                      paginationButtons,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 18),
                                SizedBox(
                                  width: 300,
                                  child: _SelectedMembersPanel(
                                    title: "Membros Selecionados :",
                                    selectedUsers: selectedUsersList,
                                    selectedIdsCount:
                                        userController.selectedUsers.length,
                                    onRemove: userController.removeUserById,
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 26),

                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 220,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (titleController.text.trim().isEmpty ||
                                      userController.selectedUsers.isEmpty) {
                                    Get.snackbar(
                                      "Campos inválidos!",
                                      "Necessário inserir os campos abaixo para prosseguir...",
                                      backgroundColor: theme.colorScheme.error,
                                      colorText: colors.onSecondary,
                                    );
                                    return;
                                  }
                            
                                  final auxProcess = FirstStageProcess(
                                    idProcess: process?.id,
                                    title: titleController.text.trim(),
                                    idsUser: userController.selectedUsers.keys
                                        .toList(),
                                    isEdit: widget.isEditMode,
                                    originalIpTypeId: process?.ipType.id.toString(),
                                    originalFormData: process?.formData,
                                  );

                                  await Get.toNamed(
                                    "/process/ip_types",
                                    arguments: auxProcess,
                                  );
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
              const SizedBox(height: 8),
              field,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                ), // 👈 O "nudge" milimétrico aqui
                child: Text(
                  label,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 18.9,
                    fontWeight: FontWeight.w700,
                    color: colors.tertiary.withOpacity(0.8),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: field,
            ),
          ],
        );
        
      },
    );
  }
}

class _MembersGrid extends StatelessWidget {
  final List<UserEntity> users;
  final Map<int, UserEntity> selectedUsersMap;
  final void Function(UserEntity user) onToggle;

  const _MembersGrid({
    required this.users,
    required this.selectedUsersMap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 600) crossAxisCount = 2;
        if (constraints.maxWidth >= 900) crossAxisCount = 3;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final u = users[index];
            final id = u.id;

            final selected = id != null && selectedUsersMap.containsKey(id);

            final fullName = _safeString(() => u.fullName, fallback: "Nome");
            final email = _safeString(() => u.email, fallback: "Email");

            return InkWell(
              key: ValueKey(id ?? index),
              borderRadius: BorderRadius.circular(10),
              onTap: id == null ? null : () => onToggle(u),
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
                    // Brilho na borda superior (Inner Highlight)
                    BoxShadow(
                      color: Colors.white.withOpacity(0.10),
                      offset: const Offset(0, 1),
                      blurRadius: 0,
                    ),
                    // Sombra real do card
                    BoxShadow(
                      color: Colors.black.withOpacity(0.30),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Row(
                  children: [
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
  final List<UserEntity> selectedUsers;
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
                  final int id = u.id!;

                  final name = _safeString(() => u.fullName, fallback: "Nome");

                  return Container(
                    key: ValueKey(id),
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


String _safeString(String Function() getter, {required String fallback}) {
  try {
    final v = getter();
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  } catch (_) {
    return fallback;
  }
}

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
