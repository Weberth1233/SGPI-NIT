import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_external_author_controller.dart';

import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../home/home_page.dart';
import 'widgets/labeled_field_row.dart';
import 'widgets/search_field_high_light.dart';

class ProcessExternalAuthorPage extends StatefulWidget {
  final bool isEditMode;
  const ProcessExternalAuthorPage({super.key, this.isEditMode = false});

  @override
  State<ProcessExternalAuthorPage> createState() =>
      _ProcessExternalAuthorPageState();
}

class _ProcessExternalAuthorPageState extends State<ProcessExternalAuthorPage> {
  final externalAuthorController = Get.find<ProcessExternalAuthorController>();

  final List<ExternalAuthorEntity>? externalAuthors =
      Get.arguments is List<ExternalAuthorEntity> ? Get.arguments : null;

  final TextEditingController searchController = TextEditingController();
  // final TextEditingController searchEmaiController = TextEditingController();
  // final TextEditingController searchCpfController = TextEditingController();


  @override
  void initState() {
    super.initState();
    
    if (externalAuthors != null && externalAuthors!.isNotEmpty) {
      externalAuthorController.externalAuthors.value = externalAuthors!;
      for (var author in externalAuthors!) {
        if (author.id != null) {
          externalAuthorController.selectedExternalAuthor[author.id!] = author;
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
    // searchEmaiController.dispose();
    // searchCpfController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Get.back(
                    result: externalAuthorController.selectedExternalAuthor,
                  ),
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                // widget.isEditMode ? "Editar Processo" : "Cadastro de Processo",
                "Autores Externos",
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
      backgroundColor: const Color(0xFFCBD5E1),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalLinesPainter(
                color: theme.colorScheme.primary.withOpacity(0.08),
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Meus Autores Externos",
                                  // widget.isEditMode
                                  //     ? "Editar seu Processo"
                                  //     : "Cadastre seu Processo",
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: colors.primary,
                                        letterSpacing: -0.1,
                                        fontSize: 35,
                                      ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await Get.toNamed(
                                    "/process/process-external-author/forms",
                                  );
                                  externalAuthorController.fetchExternalAuthors(
                                    loadMore: false,
                                  );
                                },
                                child: Text(
                                  "Cadastrar novo",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: colors.onSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          LabeledFieldRowSearch(

                            label: "Pesquisar membro",
                            field: LayoutBuilder(
                              builder: (context, constr) {
                                // Ajuste fino dos breakpoints para telas médias (tablets) e grandes (desktop)
                                final isDesktop = constr.maxWidth > 850;
                                final isTablet = constr.maxWidth > 500 && constr.maxWidth <= 850;

                                // UX: Se o usuário apagar todo o texto do input, reseta a lista de usuários.
                                void onSearchChanged(String value) {
                                  if (value.trim().isEmpty) {
                                    // Assumindo que fetchUsers() traga a lista inicial sem filtros
                                    externalAuthorController.fetchExternalAuthors();
                                  }
                                }

                                // Campos de texto para os filtros
                                final searchField = SearchFieldHighlight(
                                  title: "Nome, cpf ou email",

                                  icon: Icons.person_outline,
                                  field: CustomTextField(
                                    controller: searchController,
                                    label: "",
                                    hintText: "Ex: Nome, cpf ou email",
                                    onChanged: onSearchChanged,
                                    onFieldSubmitted: (_) =>
                                        externalAuthorController.search(searchController.text),
                                  ),
                                );

                                // final emailField = SearchFieldHighlight(
                                //   title: "E-mail",
                                //   icon: Icons.alternate_email,
                                //   field: CustomTextField(
                                //     controller: searchEmaiController,
                                //     label: "",
                                //     hintText: "Ex: joao@email.com",
                                //     onChanged: onSearchChanged,
                                //     onFieldSubmitted: (_) =>
                                //         externalAuthorController.searchByEmail(searchEmaiController.text),
                                //   ),
                                // );

                                // final cpfField = SearchFieldHighlight(
                                //   title: "CPF",
                                //   icon: Icons.badge_outlined,
                                //   field: CustomTextField(
                                //     controller: searchCpfController,
                                //     label: "",
                                //     hintText: "000.000.000-00",
                                //     onChanged: onSearchChanged,
                                //     onFieldSubmitted: (_) =>
                                //         externalAuthorController.searchByCPF(searchCpfController.text),
                                //   ),
                                // );

                                if (isDesktop) {
                                  // Desktop: Proporção ajustada. Nome e E-mail ganham mais espaço (flex: 5), CPF ganha menos (flex: 4).
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 5, child: searchField),
                                      const SizedBox(width: 16),
                                      // Expanded(flex: 5, child: emailField),
                                      // const SizedBox(width: 16),
                                      // Expanded(flex: 4, child: cpfField),
                                    ],
                                  );
                                } else if (isTablet) {
                                  // Tablet: Evita espremer os 3 campos na mesma linha. Nome e E-mail em cima, CPF embaixo.
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: searchField),
                                          const SizedBox(width: 16),
                                          // Expanded(child: emailField),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // cpfField,
                                    ],
                                  );
                                } else {
                                  // Mobile: Todos os campos empilhados com espaçamento respiro adequado.
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      searchField,
                                      const SizedBox(height: 10),
                                      // emailField,
                                      const SizedBox(height: 10),
                                      // cpfField,
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 50),

                          Obx(() {
                            if (externalAuthorController.isLoading.value &&
                                externalAuthorController
                                    .externalAuthors
                                    .isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (externalAuthorController
                                .errorMessage
                                .isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  externalAuthorController.errorMessage.value,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }

                            final list = externalAuthorController
                                .externalAuthors
                                .toList();
                            final selectedUsersList = externalAuthorController
                                .selectedExternalAuthor
                                .values
                                .toList();

                            final Widget membersView = list.isEmpty
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
                                : _MembersList(
                                    controller: externalAuthorController,
                                    externalAuthors: list,
                                    selectedMap: externalAuthorController
                                        .selectedExternalAuthor,
                                    onToggle:
                                        externalAuthorController.toggleUser,
                                  );

                            final Widget paginationButtons =
                                externalAuthorController.errorMessage.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed:
                                              externalAuthorController
                                                      .isLoading
                                                      .value ||
                                                  externalAuthorController
                                                          .page
                                                          .value ==
                                                      0
                                              ? null
                                              : () => externalAuthorController
                                                    .fetchPreviousPage(),
                                          child: const Text("Anterior"),
                                        ),
                                        const SizedBox(width: 24),
                                        Text(
                                          "Página ${externalAuthorController.page.value + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        OutlinedButton(
                                          onPressed:
                                              externalAuthorController
                                                      .isLoading
                                                      .value ||
                                                  !externalAuthorController
                                                      .hasMore
                                                      .value
                                              ? null
                                              : () => externalAuthorController
                                                    .fetchExternalAuthors(
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
                                  membersView,
                                  const SizedBox(height: 12),
                                  paginationButtons,
                                  const SizedBox(height: 16),
                                  _SelectedMembersPanel(
                                    title: "Membros Selecionados :",
                                    selectedUsers: selectedUsersList,
                                    selectedIdsCount: externalAuthorController
                                        .selectedExternalAuthor
                                        .length,
                                    onRemove:
                                        externalAuthorController.removeUserById,
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
                                      membersView,
                                      const SizedBox(height: 12),
                                      paginationButtons,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 18),
                                SizedBox(
                                  width: 320,
                                  child: _SelectedMembersPanel(
                                    title: "Membros Selecionados :",
                                    selectedUsers: selectedUsersList,
                                    selectedIdsCount: externalAuthorController
                                        .selectedExternalAuthor
                                        .length,
                                    onRemove:
                                        externalAuthorController.removeUserById,
                                  ),
                                ),
                              ],
                            );
                          }),

                          // const SizedBox(height: 26),

                          // Align(
                          //   alignment: Alignment.center,
                          //   child: SizedBox(
                          //     width: 220,
                          //     height: 44,
                          //     child: ElevatedButton(
                          //       onPressed: () async {
                          //         if (titleController.text.trim().isEmpty ||
                          //             userController.selectedUsers.isEmpty) {
                          //           Get.snackbar(
                          //             "Campos inválidos!",
                          //             "Necessário inserir os campos abaixo para prosseguir...",
                          //             backgroundColor: theme.colorScheme.error,
                          //             colorText: colors.onSecondary,
                          //           );
                          //           return;
                          //         }

                          //         final auxProcess = FirstStageProcess(
                          //           idProcess: process?.id,
                          //           title: titleController.text.trim(),
                          //           idsUser: userController.selectedUsers.keys.toList(),
                          //           isEdit: widget.isEditMode,
                          //           originalIpTypeId: process?.ipType.id.toString(),
                          //           originalFormData: process?.formData,
                          //         );

                          //         await Get.toNamed(
                          //           "/process/ip_types",
                          //           arguments: auxProcess,
                          //         );
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: colors.primary,
                          //         elevation: 0,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //       ),
                          //       child: Text(
                          //         "Próximo",
                          //         style: theme.textTheme.bodyMedium?.copyWith(
                          //           color: colors.onSecondary,
                          //           fontWeight: FontWeight.w800,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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

class _SelectedMembersPanel extends StatelessWidget {
  final String title;
  final List<ExternalAuthorEntity> selectedUsers;
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

// Transformado em uma lista limpa e simples
class _MembersList extends StatelessWidget {
  final ProcessExternalAuthorController controller;
  final List<ExternalAuthorEntity> externalAuthors;
  final Map<int, ExternalAuthorEntity> selectedMap;
  final void Function(ExternalAuthorEntity externalAuthor) onToggle;

  const _MembersList({
    required this.controller,
    required this.externalAuthors,
    required this.selectedMap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: externalAuthors.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final u = externalAuthors[index];
        final id = u.id;
        final selected = id != null && selectedMap.containsKey(id);

        final fullName = _safeString(() => u.fullName, fallback: "Nome");
        final email = _safeString(() => u.email, fallback: "Email");

        return InkWell(
          key: ValueKey(id ?? index),
          borderRadius: BorderRadius.circular(10),
          onTap: id == null ? null : () => onToggle(u),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? colors.primary.withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected
                    ? colors.primary
                    : Colors.black.withOpacity(0.08),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: colors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fullName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.tertiary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.tertiary.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (id != null) {
                                controller.deleteExternalAuthor(id);
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                              color: colors.error,
                            ),
                            tooltip: "Excluir",
                          ),

                          IconButton(
                            onPressed: () async {
                              await Get.toNamed(
                                "/process/process-external-author/forms",
                                arguments: u,
                              );
                              controller.fetchExternalAuthors(loadMore: false);
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: colors.primary,
                            ),
                            tooltip: "Editar",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle, color: colors.primary)
                else
                  Icon(
                    Icons.circle_outlined,
                    color: Colors.black.withOpacity(0.2),
                  ),
              ],
            ),
          ),
        );
      },
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
