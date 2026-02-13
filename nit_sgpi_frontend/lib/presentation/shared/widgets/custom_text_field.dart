import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/extensions/context_extensions.dart';
import 'package:flutter/services.dart';

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
  final List<TextInputFormatter>? inputFormatters;

  //  Novos parâmetros adicionados para suporte completo
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText; // <--- Adicionado
  final void Function(String)? onChanged; // <--- Adicionado

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
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.hintText, // <--- Adicionado
    this.onChanged, // <--- Adicionado
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium!.copyWith(
            color: textWhiteColor
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.tertiary,
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
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,
            onChanged: onChanged, // ✅ Repassado para o widget nativo

            style: context.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.tertiary,
            ),

            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: TextStyle(
                color: theme.colorScheme.tertiary.withOpacity(0.5),
                fontSize: 14,
              ),

              // 1. A borda padrão (visível o tempo todo)
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiary.withOpacity(
                    0.2,
                  ), // Cor suave para não poluir
                  width: 1.5,
                ),
              ),

              // 2. A borda quando o usuário clica no campo (destaque)
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary, // Cor principal do seu app
                  width: 2.0,
                ),
              ),

              // 3. A borda quando houver erro de validação
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
