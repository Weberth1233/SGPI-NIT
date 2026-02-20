import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_response_entity.dart';

import '../../../domain/entities/attachment_entity.dart';
import '../../../infra/datasources/auth_local_datasource.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // ===== Índice da seção selecionada no menu lateral
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ===== Dados recebidos pela navegação
    final entity = Get.arguments as ProcessResponseEntity;

    // ===== Tema / cores do app
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final controller = Get.find<AuthLocalDataSource>();

    // ===== Data formatada para mostrar na barra
    final dateFormatted = DateFormat(
      "d 'de' MMM 'de' y",
      "pt_BR",
    ).format(DateTime.parse(entity.createdAt.toString()));

    return Scaffold(
      // ================= AppBar (topo) - estilo do print =================
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

        // ===== Título
        title: Text(
          "Detalhes do Processo",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // ===== Fundo azul do corpo
      backgroundColor: colors.primary,

      body: Stack(
        children: [
          // ============================================================
          // 🎨 BACKGROUND — Linhas diagonais minimalistas
          // ============================================================
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: colors.onSecondary.withOpacity(0.04),
              ),
            ),
          ),

          // ============================================================
          // 📄 CONTEÚDO (desktop/web)
          // ============================================================
          SingleChildScrollView(
            child: Column(
              children: [
                // ================= BARRA DE STATUS (ponta a ponta) =================
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildProcessStatusBar(context, entity, dateFormatted),
                ),

                const SizedBox(height: 20),

                // ================= CONTEÚDO  =================
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ), // Mantém um respiro da borda

                  child: Align(
                    alignment: Alignment
                        .topLeft, // Garante alinhamento à esquerda e no topo
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1600),
                      child: _buildWideMasterDetail(context, entity),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🧭 LAYOUT DESKTOP: Menu lateral + painel à direita
  // - Sem overflow (ajusta ao espaço disponível)
  // - Tamanhos estáveis (menu fixo, painel calculado)
  // ============================================================

  Widget _buildWideMasterDetail(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // ===== largura máxima desejada (estável no desktop)
        const maxLayoutWidth = 1500.0;

        // ===== usa o que cabe de verdade (evita RenderFlex overflow)
        final totalWidth = constraints.maxWidth < maxLayoutWidth
            ? constraints.maxWidth
            : maxLayoutWidth;

        // ===== larguras fixas
        const menuWidth = 300.0;
        const gap = 24.0;

        // ===== painel direito ocupa o resto (sem Expanded, sem “esticadinha”)
        final panelWidth = totalWidth - menuWidth - gap;

        return Center(
          child: SizedBox(
            width: totalWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= MENU LATERAL (FIXO) =================
                SizedBox(
                  width: menuWidth,
                  child: _buildSideMenu(context, entity),
                ),

                const SizedBox(width: gap),

                // ================= PAINEL DIREITO (CALCULADO) =================
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
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // ✅ MENU LATERAL
  // ============================================================

  Widget _buildSideMenu(BuildContext context, ProcessResponseEntity entity) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
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

      // BLOCO SEÇOES
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Título do menu
          Text(
            "Seções",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: colors.tertiary,
            ),
          ),
          const SizedBox(height: 12),
          // ===== Tipo da Propriedade Intelectual
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.primary.withOpacity(0.15)),
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

          // ===== Itens do menu
          _buildMenuItem(
            context,
            index: 0,
            icon: Icons.person_outline,
            title: "SOLICITANTE",
            subtitle: "Quem criou o processo",
          ),
          const SizedBox(height: 10),

          _buildMenuItem(
            context,
            index: 1,
            icon: Icons.group_outlined,
            title: "MEMBROS",
            subtitle: "Vinculados ao processo",
          ),
          const SizedBox(height: 10),

          _buildMenuItem(
            context,
            index: 2,
            icon: Icons.list_alt_outlined,
            title: "DADOS DO PROCESSO",
            subtitle: "Formulário preenchido",
          ),
          const SizedBox(height: 10),

          _buildMenuItem(
            context,
            index: 3,
            icon: Icons.attach_file_outlined,
            title: "ANEXOS",
            subtitle: "Arquivos do processo",
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            index: 4,
            icon: Icons.approval,
            title: "CORREÇÃO",
            subtitle: "Correções do processo",
          ),
          SizedBox(height: 10,),

          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Aprovar", style: theme.textTheme.bodyMedium!.copyWith(
                color: colors.onSecondary,
              ),)),
              ElevatedButton(onPressed: () {
                Get.toNamed('/home/process-detail/justification', arguments: entity.id);
              }, child: Text("Correção", style: theme.textTheme.bodyMedium!.copyWith(
                color: colors.onSecondary,))),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      color: colors.tertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.secondary,
                    ),
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

  // ============================================================
  // 📌 Painel direito: conteúdo conforme seleção
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
        title = "CORREÇÕES";
        subtitle = "Correções relacionadas ao processo.";
        content = _buildFixesList(context, entity);
        break;
      default:
        title = "SEÇÃO";
        subtitle = "";
        content = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Título do painel
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colors.tertiary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 6),

        // ===== Subtítulo
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.secondary),
        ),
        const SizedBox(height: 18),

        // ===== Conteúdo
        content,
      ],
    );
  }

  // ============================================================
  // 👥 Lista de membros
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return entity.justifications.isEmpty
        ? const SizedBox(
            child: Text("Não há correções relacionadas a esse processo!"),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entity.justifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final procesJustification = entity.justifications[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {},
                  child: _buildSimpleCard(
                    context,
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: colors.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                procesJustification.id.toString(),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.tertiary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                procesJustification.reason,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  // ============================================================
  // 📎 Lista de anexos
  // ============================================================
  Widget _buildAttachmentsList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.attachments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final AttachmentEntity attachment = entity.attachments[index];
        final isSigned = attachment.signedFilePath.isNotEmpty;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () {
              Get.toNamed(
                "/home/process-detail/attachments",
                arguments: attachment,
              );
            },
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
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.tertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          attachment.status,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.secondary,
                          ),
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSigned ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= BARRA DE STATUS (Header slim) =================
  Widget _buildProcessStatusBar(
    BuildContext context,
    ProcessResponseEntity entity,
    String date,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final title = entity.title.isNotEmpty ? entity.title : entity.ipType.name;
    final statusUI = _statusUi(context, entity.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
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
          // ===== Indicador lateral
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(
              color: statusUI.color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),

          // ===== Nome + ID/data
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
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: colors.tertiary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID #${entity.id} • $date",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 15,
                    color: colors.secondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ===== Chip de status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: statusUI.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: statusUI.color.withOpacity(0.28)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusUI.icon, size: 16, color: statusUI.color),
                const SizedBox(width: 6),
                Text(
                  statusUI.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: statusUI.color,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= Helper: Status UI =================

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

  // ================= Card interno padrão =================
  Widget _buildSimpleCard(BuildContext context, {required Widget child}) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.09)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ================= Solicitante =================

  Widget _buildCreatorCard(BuildContext context, ProcessResponseEntity entity) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _buildSimpleCard(
      context,
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colors.primary,
            child: Text(
              entity.creator.fullName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: colors.onSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entity.creator.fullName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entity.creator.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= Membros (card por pessoa) =================

  Widget _buildPersonRowCard(
    BuildContext context, {
    required String name,
    required String email,
    required IconData trailingIcon,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _buildSimpleCard(
      context,
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.secondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(trailingIcon, color: colors.secondary),
        ],
      ),
    );
  }

  // ================= Formulário dinâmico =================

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
          value: value.toString(),
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: isTextArea ? 1.5 : 1.2,
              color: colors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Model simples pra carregar os valores do status

class _StatusUi {
  final Color color;
  final IconData icon;
  final String label;

  _StatusUi({required this.color, required this.icon, required this.label});
}

// ============================================================
// 🎨 Painter — Linhas diagonais minimalistas (background)
// ============================================================
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
