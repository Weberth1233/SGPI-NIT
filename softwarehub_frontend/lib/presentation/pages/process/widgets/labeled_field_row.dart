
// Wrapper para campos de texto simples (ex: Título do processo)
import 'package:flutter/material.dart';

class LabeledFieldRowSimple extends StatelessWidget {
  final String label;
  final Widget field;

  const LabeledFieldRowSimple({super.key, required this.label, required this.field});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 180,
              // Padding artificial MANTIDO aqui apenas para alinhar
              // o texto com o centro da caixa de texto do input.
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  label,
                  textAlign: TextAlign.start,
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
            Expanded(child: field),
          ],
        );
      },
    );
  }
}

// Wrapper para o bloco complexo de pesquisa (Sem offset artificial)
class LabeledFieldRowSearch extends StatelessWidget {
  final String label;
  final Widget field;

  const LabeledFieldRowSearch({super.key, required this.label, required this.field});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 180,
              // Offset artificial REMOVIDO para que o "Pesquisar Membros:"
              // alinhe perfeitamente com os textos "Nome", "E-mail" e "CPF".
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  label,
                  textAlign: TextAlign.start,
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
            Expanded(child: field),
          ],
        );
      },
    );
  }
}
