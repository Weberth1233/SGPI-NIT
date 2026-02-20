import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_response_entity.dart';
import 'controllers/process_detail_controller.dart';

class ProcessDetailPage extends StatefulWidget {
  const ProcessDetailPage({super.key});

  @override
  State<ProcessDetailPage> createState() => _ProcessDetailPageState();
}

class _ProcessDetailPageState extends State<ProcessDetailPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProcessDetailController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: colors.primary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Detalhes do Processo",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontSize: 20, // Reduzido levemente para caber melhor no mobile
          ),
        ),
      ),
      backgroundColor: colors.primary,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: colors.error),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: colors.onSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    if (controller.process.value?.id != null) {
                      controller.fetchProcess(controller.process.value!.id);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colors.onSecondary,
                  ),
                  child: Text(
                    "Tentar novamente",
                    style: TextStyle(color: colors.primary),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.process.value == null) {
          return Center(
            child: Text(
              "Processo não encontrado.",
              style: TextStyle(color: colors.onSecondary),
            ),
          );
        }

        final entity = controller.process.value!;
        final dateFormatted = DateFormat(
          "d 'de' MMM 'de' y",
          "pt_BR",
        ).format(DateTime.parse(entity.createdAt.toString()));

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DiagonalLinesPainter(
                  color: colors.onSecondary.withOpacity(0.04),
                ),
              ),
            ),

            // ============================================================
            // 📐 LAYOUT BUILDER PARA RESPONSIVIDADE
            // ============================================================
            LayoutBuilder(
              builder: (context, constraints) {
                // Definimos 900 de largura como o limite entre Mobile/Tablet e Desktop
                final isDesktop = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: _buildProcessStatusBar(
                          context,
                          entity,
                          dateFormatted,
                          isDesktop,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1600),
                            // Renderiza diferente baseado no tamanho da tela
                            child: isDesktop
                                ? _buildWideMasterDetail(
                                    context,
                                    entity,
                                    controller,
                                    constraints.maxWidth,
                                  )
                                : _buildNarrowMasterDetail(
                                    context,
                                    entity,
                                    controller,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  // ============================================================
  // 🧭 LAYOUT DESKTOP (Telas Largas)
  // ============================================================
  Widget _buildWideMasterDetail(
    BuildContext context,
    ProcessResponseEntity entity,
    ProcessDetailController controller,
    double availableWidth,
  ) {
    final colors = Theme.of(context).colorScheme;
    const maxLayoutWidth = 1500.0;
    final totalWidth = availableWidth < maxLayoutWidth
        ? availableWidth
        : maxLayoutWidth;
    const menuWidth = 300.0;
    const gap = 24.0;
    final panelWidth = totalWidth - menuWidth - gap;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: menuWidth,
          child: _buildDesktopSideMenu(context, entity, controller),
        ),
        const SizedBox(width: gap),
        SizedBox(
          width: panelWidth,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.onSecondary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _buildSelectedContent(context, entity),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 📱 LAYOUT MOBILE (Telas Estreitas)
  // ============================================================
  Widget _buildNarrowMasterDetail(
    BuildContext context,
    ProcessResponseEntity entity,
    ProcessDetailController controller,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Informação do Tipo de Propriedade
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.onSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tipo da Propriedade Intelectual",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entity.ipType.name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.tertiary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Menu Horizontal Rolável (Abas)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMobileMenuItem(
                context,
                index: 0,
                icon: Icons.person_outline,
                title: "Solicitante",
              ),
              _buildMobileMenuItem(
                context,
                index: 1,
                icon: Icons.group_outlined,
                title: "Membros",
              ),
              _buildMobileMenuItem(
                context,
                index: 2,
                icon: Icons.list_alt_outlined,
                title: "Dados",
              ),
              _buildMobileMenuItem(
                context,
                index: 3,
                icon: Icons.attach_file_outlined,
                title: "Anexos",
              ),
              _buildMobileMenuItem(
                context,
                index: 4,
                icon: Icons.approval,
                title: "Correção",
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Área de Conteúdo
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.onSecondary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _buildSelectedContent(context, entity),
        ),

        // 4. Botões de Admin no Mobile
        if (controller.isAdmin) ...[
          const SizedBox(height: 24),
          Text(
            "Ações Administrativas",
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSecondary,
              fontWeight: FontWeight.bold,
              
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Aprovar",
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(
                    '/process-detail/justification',
                    arguments: entity.id,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Correção",
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ============================================================
  // COMPONENTES DE MENU
  // ============================================================

  // Menu Item para Desktop
  Widget _buildDesktopSideMenu(
    BuildContext context,
    ProcessResponseEntity entity,
    ProcessDetailController controller,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Seções",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: colors.tertiary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tipo da Propriedade Intelectual",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entity.ipType.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDesktopMenuItem(
            context,
            index: 0,
            icon: Icons.person_outline,
            title: "SOLICITANTE",
            subtitle: "Quem criou o processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 1,
            icon: Icons.group_outlined,
            title: "MEMBROS",
            subtitle: "Vinculados ao processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 2,
            icon: Icons.list_alt_outlined,
            title: "DADOS DO PROCESSO",
            subtitle: "Formulário preenchido",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 3,
            icon: Icons.attach_file_outlined,
            title: "ANEXOS",
            subtitle: "Arquivos do processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 4,
            icon: Icons.approval,
            title: "CORREÇÃO",
            subtitle: "Correções do processo",
          ),

          if (controller.isAdmin) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              "Ações Administrativas",
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    "Aprovar",
                    style: TextStyle(color: colors.onSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Get.toNamed(
                    '/process-detail/justification',
                    arguments: entity.id,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    "Correção",
                    style: TextStyle(color: colors.onSecondary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopMenuItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = _selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.10) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colors.primary.withOpacity(0.35)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? colors.primary : colors.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colors.tertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colors.secondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.secondary),
          ],
        ),
      ),
    );
  }

  // Menu Item para Mobile (Estilo "Pílula"/Chip)
  Widget _buildMobileMenuItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.onSecondary
                : colors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : colors.onSecondary.withOpacity(0.2),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? colors.primary : colors.onSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? colors.primary : colors.onSecondary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PAINEL DE CONTEÚDO (Compartilhado entre Desktop e Mobile)
  // ============================================================
  Widget _buildSelectedContent(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    String title;
    String subtitle;
    Widget content;

    switch (_selectedIndex) {
      case 0:
        title = "SOLICITANTE";
        subtitle = "Dados de quem criou o processo.";
        content = _buildCreatorCard(context, entity);
        break;
      case 1:
        title = "MEMBROS";
        subtitle = "Pessoas vinculadas ao processo.";
        content = _buildMembersList(context, entity);
        break;
      case 2:
        title = "DADOS DO PROCESSO";
        subtitle = "Informações preenchidas no formulário.";
        content = _buildDynamicForm(context, entity);
        break;
      case 3:
        title = "ANEXOS";
        subtitle = "Arquivos relacionados ao processo.";
        content = _buildAttachmentsList(context, entity);
        break;
      case 4:
        title = "CORREÇÕES / JUSTIFICATIVAS";
        subtitle = "Correções e observações.";
        content = _buildFixesList(context, entity);
        break;
      default:
        title = "";
        subtitle = "";
        content = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colors.tertiary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.secondary),
        ),
        const SizedBox(height: 18),
        content,
      ],
    );
  }

  // ============================================================
  // WIDGETS INTERNOS (Listas e Cards)
  // ============================================================
  Widget _buildMembersList(BuildContext context, ProcessResponseEntity entity) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.authors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final author = entity.authors[index];
        return _buildPersonRowCard(
          context,
          name: author.fullName,
          email: author.email,
          trailingIcon: Icons.person_outline,
        );
      },
    );
  }

  Widget _buildFixesList(BuildContext context, ProcessResponseEntity entity) {
    return entity.justifications.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Não há correções ou justificativas."),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entity.justifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final justification = entity.justifications[index];
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  border: Border.all(color: Colors.amber.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.sticky_note_2_outlined,
                      color: Colors.amber.shade800,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Observação #${justification.id}",
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            justification.reason,
                            style: TextStyle(
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildAttachmentsList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.attachments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final attachment = entity.attachments[index];
        final isSigned = attachment.signedFilePath.isNotEmpty;

        return InkWell(
          onTap: () => Get.toNamed(
            "/home/process-detail/attachments",
            arguments: attachment,
          ),
          child: _buildSimpleCard(
            context,
            child: Row(
              children: [
                Icon(
                  isSigned ? Icons.check_circle : Icons.description_outlined,
                  color: isSigned ? Colors.green : colors.secondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: colors.tertiary,
                        ),
                      ),
                      Text(
                        attachment.status,
                        style: TextStyle(color: colors.secondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isSigned ? Colors.green : Colors.orange)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isSigned ? "Assinado" : "Pendente",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: isSigned ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER E CARDS AUXILIARES
  // ============================================================
  Widget _buildProcessStatusBar(
    BuildContext context,
    ProcessResponseEntity entity,
    String date,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final title = entity.title.isNotEmpty ? entity.title : entity.ipType.name;
    final statusUI = _statusUi(context, entity.status);

    return Container(
      width: double.infinity,
      // Ajuste de padding para mobile
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 25 : 16,
        vertical: isDesktop ? 25 : 16,
      ),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(
              color: statusUI.color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: isDesktop ? 25 : 18,
                    fontWeight: FontWeight.w900,
                    color: colors.tertiary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID #${entity.id} • $date",
                  style: TextStyle(fontSize: 13, color: colors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 15 : 10,
              vertical: isDesktop ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: statusUI.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusUI.icon, size: 14, color: statusUI.color),
                if (isDesktop) const SizedBox(width: 6),
                if (isDesktop)
                  Text(
                    statusUI.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: statusUI.color,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusUi _statusUi(BuildContext context, String status) {
    final colors = Theme.of(context).colorScheme;
    Color color;
    IconData icon;
    String label = status.replaceAll('_', ' ').toUpperCase();
    switch (status) {
      case 'EM_ANDAMENTO':
        color = Colors.orange;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'CONCLUIDO':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'CANCELADO':
        color = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      default:
        color = colors.secondary;
        icon = Icons.info_outline;
    }
    return _StatusUi(color: color, icon: icon, label: label);
  }

  Widget _buildSimpleCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.09)),
      ),
      child: child,
    );
  }

  Widget _buildCreatorCard(BuildContext context, ProcessResponseEntity entity) {
    return _buildPersonRowCard(
      context,
      name: entity.creator.fullName,
      email: entity.creator.email,
      trailingIcon: Icons.star_border,
    );
  }

  Widget _buildPersonRowCard(
    BuildContext context, {
    required String name,
    required String email,
    required IconData trailingIcon,
  }) {
    final colors = Theme.of(context).colorScheme;
    return _buildSimpleCard(
      context,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colors.primary,
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: colors.onSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: colors.tertiary,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(color: colors.secondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(trailingIcon, color: colors.secondary),
        ],
      ),
    );
  }

  Widget _buildDynamicForm(BuildContext context, ProcessResponseEntity entity) {
    final fieldsStructure = entity.ipType.formStructure.fields;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fieldsStructure.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final fieldDef = fieldsStructure[index];
        final value = entity.formData[fieldDef.name];
        return _buildFieldItem(
          context,
          label: fieldDef.name,
          value: value != null ? value.toString() : 'N/A',
          type: fieldDef.type,
        );
      },
    );
  }

  Widget _buildFieldItem(
    BuildContext context, {
    required String label,
    required String value,
    required String type,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isTextArea = type == 'textArea';
    return _buildSimpleCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isTextArea ? Icons.description_outlined : Icons.short_text,
                size: 16,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: colors.tertiary,
              height: isTextArea ? 1.5 : 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusUi {
  final Color color;
  final IconData icon;
  final String label;
  _StatusUi({required this.color, required this.icon, required this.label});
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
