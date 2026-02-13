import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_response_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entity = Get.arguments as ProcessResponseEntity;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final dateFormatted = DateFormat(
      "d 'de' MMM 'de' y",
      "pt_BR",
    ).format(DateTime.parse(entity.createdAt.toString()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Processo"),
        backgroundColor: colors.primary,
        foregroundColor: colors.onSecondary,
        elevation: 0,
      ),
      backgroundColor: colors.onSecondary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Container(
          margin: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, entity, dateFormatted),

              const SizedBox(height: 24),

              _buildSectionTitle(context, "Solicitante"),
              const SizedBox(height: 12),
              _buildCreatorCard(context, entity),

              const SizedBox(height: 24),
              _buildSectionTitle(context, "Membros"),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entity.authors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final author = entity.authors[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: Text(
                            author.fullName.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                author.fullName,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                author.email,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.person_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle(context, "Dados do Processo"),
              const SizedBox(height: 12),
              _buildDynamicForm(context, entity),

              const SizedBox(height: 24),

              _buildSectionTitle(context, "Anexos"),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: (){
                Get.toNamed("/home/process-detail/attachments", arguments: entity.id);
              }, child: Text("Visualizar documentos", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),))
            
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(
    BuildContext context,
    ProcessResponseEntity entity,
    String date,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final title = entity.title.isNotEmpty ? entity.title : entity.ipType.name;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusBadge(context, entity.status),
              Text(
                "ID #${entity.id}",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.onSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: colors.onSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final colors = Theme.of(context).colorScheme;

    Color color;
    IconData icon;
    String label = status.replaceAll('_', ' ');

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CRIADOR =================

  Widget _buildCreatorCard(BuildContext context, ProcessResponseEntity entity) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: colors.primary,
          child: Text(
            entity.creator.fullName.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: colors.onSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          entity.creator.fullName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.tertiary,
          ),
        ),
        subtitle: Text(
          entity.creator.email,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.secondary),
        ),
      ),
    );
  }

  // ================= FORMULÁRIO =================

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Text(
      title,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colors.tertiary,
      ),
    );
  }
}
