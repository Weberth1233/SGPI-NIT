import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infra/datasources/auth_local_datasource.dart';

class CustomMenu extends StatelessWidget {
  final Widget child;

  const CustomMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800; // Define o ponto de quebra (breakpoint)

    // === MODO MOBILE ===
    if (isMobile) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        appBar: AppBar(
          title: const Text("NIT SGPI", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        drawer: Drawer(
          width: 100, // Mantém a largura original do seu design
          backgroundColor: theme.colorScheme.primary,
          child: _MenuContent(theme: theme), // Reusa o conteúdo
        ),
        body: child,
      );
    }

    // === MODO DESKTOP ===
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: double.infinity,
            width: 100,
            color: theme.colorScheme.primary,
            // Reusa o mesmo conteúdo do menu mobile
            child: _MenuContent(theme: theme),
          ),
          // Conteúdo da página
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// =======================
/// Conteúdo do Menu (Compartilhado)
/// =======================
class _MenuContent extends StatelessWidget {
  final ThemeData theme;

  const _MenuContent({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Logo (com tratamento de erro caso não carregue nos testes)
          Image.asset(
            "assets/images/Logo SGPI-Photoroom 1.png",
            width: 100,
            errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.image_not_supported, color: Colors.white),
          ),
          const SizedBox(height: 3),
          
          /// Itens do Menu
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "𝙉𝙄𝙏",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 50), // Ajustei o espaçamento para ficar flexível
                
                // Botões de navegação (Dica: Use IconButton ou InkWell para cliques)
                Icon(Icons.home, color: Colors.white, size: 30),
                SizedBox(height: 30),
                Icon(Icons.settings, color: Colors.white, size: 30),
              ],
            ),
          ),

          _UserSection(theme: theme),
        ],
      ),
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
    final controller = Get.find<AuthLocalDataSource>();

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
        
        // Corrigi o botão: Havia um TextButton dentro de um ElevatedButton
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.clearToken();
              Get.offAllNamed("/login"); // Use offAllNamed para limpar histórico ao sair
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