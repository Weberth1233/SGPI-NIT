import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/extensions/context_extensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final double? size;
  
  const CustomTextField({super.key, required this.controller, required this.label, this.obscureText = false, this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 7,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodyMedium,),
        SizedBox(
                    width: size,
                    child: TextField(
                      obscureText: obscureText,
                      style: context.textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary),
                      controller: controller,
                    ),
                  ),
      ],
    );
  }
}