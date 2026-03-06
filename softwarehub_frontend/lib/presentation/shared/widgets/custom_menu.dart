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
    final isMobile = width < 800; 

    if (isMobile) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        appBar: AppBar(
          title: const Text(
            "NIT SGPI",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        drawer: Drawer(
          width: 100, 
          backgroundColor: theme.colorScheme.primary,
          child: _MenuContent(theme: theme), 
        ),
        body: child,
      );
    }

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
            child: _MenuContent(theme: theme),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _MenuContent extends StatelessWidget {
  final ThemeData theme;

  const _MenuContent({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Text(
                  "NIT",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
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
                  "SOFTWAREHUB",
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 50,
                ), 
                // Icon(Icons.home, color: Colors.white, size: 30),
                // SizedBox(height: 30),
                // Icon(Icons.settings, color: Colors.white, size: 30),
              ],
            ),
          ),

          _UserSection(theme: theme),
        ],
      ),
    );
  }
}
class _UserSection extends StatelessWidget {
  final ThemeData theme;

  const _UserSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthLocalDataSource>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: theme.colorScheme.tertiary,
          child:  Center(
            child: IconButton(onPressed: (){
            Get.toNamed("/user-logged");
            },icon: Icon(Icons.person, size: 25,), color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        
        FutureBuilder<String?>(
          future: controller.getRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final role = snapshot.data;
            if (role == 'ADMIN') {
              return Text("Admin", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold));
            } else {
              return Text("Usuário", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSecondary,));
            }
          },
        ),
        const SizedBox(height: 10),
        // Corrigi o botão: Havia um TextButton dentro de um ElevatedButton
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.clear();
              Get.offAllNamed(
                "/login",
              ); // Use offAllNamed para limpar histórico ao sair
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
