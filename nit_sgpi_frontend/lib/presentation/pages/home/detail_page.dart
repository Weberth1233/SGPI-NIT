import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Importante para formatar datas
import 'package:nit_sgpi_frontend/domain/entities/process/process_response_entity.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entity = Get.arguments as ProcessResponseEntity;
    final theme = Theme.of(context);

    // Formata data: 11 de fev de 2026
    final dateFormatted = DateFormat("d 'de' MMM 'de' y", "pt_BR")
        .format(DateTime.parse(entity.createdAt.toString()));

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: theme.colorScheme.onSecondary,
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER: Título e Status
              _buildHeader(context, entity, dateFormatted),
          
              const SizedBox(height: 24),
          
              // 2. CRIADOR: Quem fez a solicitação
              _buildSectionTitle(context, "Solicitante"),
              const SizedBox(height: 12),
              _buildCreatorCard(context, entity),
          
              const SizedBox(height: 24),
          
              // 3. FORMULÁRIO DINÂMICO: Renderiza baseado na estrutura
              _buildSectionTitle(context, "Dados do Processo"),
              const SizedBox(height: 12),
              _buildDynamicForm(context, entity),
          
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- SEÇÃO 1: Header (Card Principal) ---
  Widget _buildHeader(BuildContext context, ProcessResponseEntity entity, String date) {
    final theme = Theme.of(context);
    final title = entity.title.isNotEmpty ? entity.title : entity.ipType.name;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
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
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, 
                size: 16, color: theme.colorScheme.secondary),
              const SizedBox(width: 6),
              Text(
                date,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color color;
    IconData icon;
    String label = status.replaceAll('_', ' ');

    // Lógica de cores baseada no status "EM_ANDAMENTO"
    switch (status) {
      case 'EM_ANDAMENTO':
        color = Colors.orange.shade700;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'CONCLUIDO':
        color = Colors.green.shade700;
        icon = Icons.check_circle_outline;
        break;
      case 'CANCELADO':
        color = Colors.red.shade700;
        icon = Icons.cancel_outlined;
        break;
      default:
        color = Colors.blue.shade700;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
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

  // --- SEÇÃO 2: Card do Criador ---
  Widget _buildCreatorCard(BuildContext context, ProcessResponseEntity entity) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Text(
            entity.creator.fullName.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          entity.creator.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(entity.creator.email),
      ),
    );
  }

  // --- SEÇÃO 3: Formulário Inteligente ---
  Widget _buildDynamicForm(BuildContext context, ProcessResponseEntity entity) {
    // 1. Pegamos a lista de campos da ESTRUTURA (que tem o 'type')
    // Nota: Assumindo que você mapeou 'formStructure' e 'fields' na sua entidade ipType
    // Se sua entidade ipType não tem formStructure mapeado ainda, avise que ajustamos.
    // Vou assumir que structure -> fields é uma lista acessível.
    
    // Fallback: Se não tiver estrutura mapeada, usa as chaves do map direto
    final fieldsStructure = entity.ipType.formStructure.fields; 
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fieldsStructure.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final fieldDef = fieldsStructure[index];
        final value = entity.formData[fieldDef.name]; // Busca o valor usando o nome

        return _buildFieldItem(
          context, 
          label: fieldDef.name, 
          value: value.toString(), 
          type: fieldDef.type
        );
      },
    );
  }

  Widget _buildFieldItem(BuildContext context, {required String label, required String value, required String type}) {
    final theme = Theme.of(context);
    final isTextArea = type == 'textArea';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow ?? Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícone baseado no tipo
              Icon(
                isTextArea ? Icons.description_outlined : Icons.short_text,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Se for textArea, damos mais respiro e estilo de parágrafo
          isTextArea 
          ? Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            )
          : Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}