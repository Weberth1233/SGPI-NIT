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

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final void Function(String)? onChanged;

  // ✅ Novos parâmetros
  final int? maxLines;
  final int? minLines;

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
    this.hintText,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      spacing: 7, // Flutter 3.24+
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
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onTap: onTap,
            readOnly: readOnly,
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,
            onChanged: onChanged,

            // ✅ Controle de linhas
            maxLines: obscureText ? 1 : maxLines,
            minLines: minLines,

            style: context.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.tertiary,
            ),

            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical:
                    16, // Garanta que este valor seja simétrico (igual em cima e embaixo)
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: TextStyle(
                color: theme.colorScheme.tertiary.withOpacity(0.5),
                fontSize: 14,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2.0,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),

            ),
          ),
        ),
      ],
    );
  }
}
