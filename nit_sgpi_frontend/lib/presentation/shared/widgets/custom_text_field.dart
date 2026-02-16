import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/extensions/context_extensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final double? size;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool textWhiteColor;
  final void Function(String)? onFieldSubmitted;
  
  // Nova propriedade para controlar as linhas (TextArea)
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.size,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.textWhiteColor = false,
    this.onFieldSubmitted,
    // Define 1 como padrão para manter o comportamento original.
    // Para virar TextArea, passe um número maior ou null.
    this.maxLines = 1, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 7, // Requer Flutter 3.24+
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium!.copyWith(
            color: textWhiteColor
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: size,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onTap: onTap,
            readOnly: readOnly,
            maxLines: maxLines, // 👈 Aqui a mágica acontece
            style: context.textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}