import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_external_author_controller.dart';

import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../home/home_page.dart';
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
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Barra de Pesquisa Unificada
    final Widget searchFieldWidget = SearchFieldHighlight(
      title: "Nome, CPF ou E-mail",
      icon: Icons.search,
      field: CustomTextField(
        controller: searchController,
        label: "",
        hintText: "Ex: Nome, CPF ou E-mail...",
        onChanged: (value) {
          if (value.trim().isEmpty) {
            externalAuthorController.fetchExternalAuthors();
          }
        },
        onFieldSubmitted: (_) =>
            externalAuthorController.search(searchController.text),
      ),
    );

    // FUNÇÃO DE SALVAR (Faz a exata mesma coisa que o botão voltar do AppBar)
    void handleSaveAndBack() {
      Get.back(
        result: externalAuthorController.selectedExternalAuthor,
      );
    }

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
                  onPressed: handleSaveAndBack, // Usando a mesma função aqui
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Colaboradores externos",
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
                                  "Colaboradores externos",
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: colors.primary,
                                    letterSpacing: -0.1,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await Get.toNamed("/process/process-external-author/forms");
                                  externalAuthorController.fetchExternalAuthors(loadMore: false);
                                },
                                icon: const Icon(Icons.add, size: 20),
                                label: Text(
                                  "Cadastrar novo",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  elevation: 4,
                                  shadowColor: colors.primary.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          Obx(() {
                            if (externalAuthorController.isLoading.value &&
                                externalAuthorController.externalAuthors.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (externalAuthorController.errorMessage.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  externalAuthorController.errorMessage.value,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }

                            final list = externalAuthorController.externalAuthors.toList();
                            final selectedUsersList = externalAuthorController.selectedExternalAuthor.values.toList();

                            final Widget membersView = list.isEmpty
                                ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Sem resultados!",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                                : _MembersList(
                              controller: externalAuthorController,
                              externalAuthors: list,
                              selectedMap: externalAuthorController.selectedExternalAuthor,
                              onToggle: externalAuthorController.toggleUser,
                            );

                            final Widget paginationButtons = externalAuthorController.errorMessage.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: externalAuthorController.isLoading.value ||
                                        externalAuthorController.page.value == 0
                                        ? null
                                        : () => externalAuthorController.fetchPreviousPage(),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      side: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    child: const Text("Anterior"),
                                  ),
                                  const SizedBox(width: 24),
                                  Text(
                                    "Página ${externalAuthorController.page.value + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 24),
                                  OutlinedButton(
                                    onPressed: externalAuthorController.isLoading.value ||
                                        !externalAuthorController.hasMore.value
                                        ? null
                                        : () => externalAuthorController.fetchExternalAuthors(loadMore: true),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      side: BorderSide(color: Colors.grey.shade300),
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
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                          ),
                                          child: Text(
                                            "Autores Disponíveis",
                                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                          child: searchFieldWidget,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: membersView,
                                        ),
                                        paginationButtons,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _SelectedMembersPanel(
                                    title: "Colaboradores selecionados",
                                    selectedUsers: selectedUsersList,
                                    selectedIdsCount: externalAuthorController.selectedExternalAuthor.length,
                                    onRemove: externalAuthorController.removeUserById,
                                    onSave: handleSaveAndBack, // Passando a função de salvar
                                  ),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                          ),
                                          child: Text(
                                            "Autores Disponíveis",
                                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                          child: searchFieldWidget,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: membersView,
                                        ),
                                        paginationButtons,
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                                  child: Column(
                                    children: [
                                      Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 30),
                                      Icon(Icons.chevron_left, color: Colors.grey.shade400, size: 30),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _SelectedMembersPanel(
                                        title: "Colaboradores Selecionados",
                                        selectedUsers: selectedUsersList,
                                        selectedIdsCount: externalAuthorController.selectedExternalAuthor.length,
                                        onRemove: externalAuthorController.removeUserById,
                                        onSave: handleSaveAndBack,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
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
  final VoidCallback onSave; // Recebe a função de salvar

  const _SelectedMembersPanel({
    required this.title,
    required this.selectedUsers,
    required this.selectedIdsCount,
    required this.onRemove,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 480, // Aumentei um pouco para acomodar o novo botão confortavelmente
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$selectedIdsCount",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: selectedIdsCount == 0
                ? Center(
              child: Text(
                "Nenhum selecionado",
                style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: selectedUsers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final u = selectedUsers[i];
                final int id = u.id!;
                final name = _safeString(() => u.fullName, fallback: "Nome");

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      _safeString(() => u.email, fallback: "Email"),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)
                  ),
                  trailing: IconButton(
                    tooltip: "Remover",
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onRemove(id),
                    icon: const Icon(Icons.close, size: 20, color: Colors.redAccent),
                  ),
                );
              },
            ),
          ),
          // NOVO BOTÃO SALVAR NO RODAPÉ
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.check_circle_outline, size: 22),
              label: Text(
                "SALVAR SELEÇÃO",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary, // Transmite segurança sendo a cor principal
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                elevation: 3,
                shadowColor: colors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
          borderRadius: BorderRadius.circular(8),
          onTap: id == null ? null : () => onToggle(u),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Colors.grey.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? Colors.grey.shade400 : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fullName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (id != null) {
                                controller.deleteExternalAuthor(id);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.delete_outline, size: 18, color: colors.error),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () async {
                              await Get.toNamed("/process/process-external-author/forms", arguments: u);
                              controller.fetchExternalAuthors(loadMore: false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.edit_outlined, size: 18, color: colors.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check, color: Colors.black54)
                else
                  const Icon(Icons.add_circle_outline, color: Colors.black87),
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