import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final Widget child;

  const CustomMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: double.infinity,
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              Image.asset("assets/images/Logo SGPI-Photoroom 1.png", width: 100),
              const SizedBox(height:3),
              /// Menu central
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "𝙉𝙄𝙏",
                      style: const TextStyle(
                     fontSize: 25,
                     fontWeight: FontWeight.w900,
                     letterSpacing: 2.0,
                     color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 136),
                    Icon(Icons.home, color: Colors.white),
                    SizedBox(height: 20),
                    Icon(Icons.person, color: Colors.white),
                  ],
                ),
              ),

              _UserSection(theme: theme),
            ],
          ),
        ),

        Expanded(child: child),
      ],
    );
  }
}

/// =======================
/// Seção do usuário
/// =======================
class _UserSection extends StatelessWidget {
  final ThemeData theme;

  const _UserSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: theme.colorScheme.tertiary,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          "Usuário",
          style: theme.textTheme.bodySmall!.copyWith(color: Colors.white),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: logout
              // Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "SAIR",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
        ),
      ],
    );
  }
}
