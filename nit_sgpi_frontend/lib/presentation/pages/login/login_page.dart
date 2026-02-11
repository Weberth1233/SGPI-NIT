import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/login/controllers/login_controller.dart';

import '../../shared/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(
    text: 'marialurdes123@gmail.com',
  );
  final _passwordController = TextEditingController(text: 'marialurdes123');
  final loginController = Get.find<LoginController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ Background: Linhas diagonais minimalistas + Glow radial atrás da logo
  Widget _bgDiagonalLines(ThemeData theme) {
    return Stack(
      children: [
        // cor base
        Container(color: theme.colorScheme.primary),

        //linhas diagonais (padrão sutil)
        Positioned.fill(
          child: CustomPaint(
            painter: _DiagonalLinesPainter(
              color: theme.colorScheme.onPrimary.withOpacity(0.040),
              spacing: 70,
              strokeWidth: 2,
            ),
          ),
        ),

        //Glow radial atrás da logo
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.25),
                radius: 0.50,
                colors: [
                  Colors.white.withOpacity(0.11),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          _bgDiagonalLines(theme),

          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/Logo SGPI-Photoroom 1.png"),
                  Text(
                    '𝙉𝙄𝙏',
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: "LOGIN",
                    controller: _emailController,
                    size: 447,
                    textWhiteColor: true,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "SENHA",
                    controller: _passwordController,
                    obscureText: true,
                    size: 447,
                    textWhiteColor: true,
                  ),
                  const SizedBox(height: 24),

                  Obx(() {
                    final error = loginController.errorMessage.value;
                    if (error.isEmpty) return const SizedBox(height: 20);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(error, style: const TextStyle(color: Colors.red)),
                    );
                  }),

                  Obx(
                    () => SizedBox(
                      width: 447,
                      height: 44,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(theme.colorScheme.onSecondary),
                        ),
                        onPressed: loginController.loading.value
                            ? null
                            : () {
                                loginController.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                        child: loginController.loading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Login"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 23),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nao tem cadastro ? ",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed("/register"),
                        child: Text(
                          "Fazer cadastro",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.yellow,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double strokeWidth;

  _DiagonalLinesPainter({
    required this.color,
    required this.spacing,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    // Linhas diagonais: varre além do tamanho para cobrir tudo
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DiagonalLinesPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.spacing != spacing ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
