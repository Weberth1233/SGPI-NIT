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
    text: 'marialurdes1234@gmail.com',
  );
  final _passwordController = TextEditingController(text: 'marialurdes123');
  final loginController = Get.find<LoginController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //  Background: Linhas diagonais minimalistas + Glow radial atrás da logo
  Widget _bgDiagonalLines(ThemeData theme) {
    return Stack(
      children: [
        // cor base
        Container(color: theme.colorScheme.primary),

        //linhas diagonais
        Positioned.fill(
          child: CustomPaint(
            painter: _DiagonalLinesPainter(
              color: theme.colorScheme.onPrimary.withOpacity(0.030),
              spacing: 70,
              strokeWidth: 1.5,
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
                colors: [Colors.white.withOpacity(0.15), Colors.transparent],
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

                  const SizedBox(height: 45),

                  CustomTextField(
                    label: "𝗘-𝗠𝗔𝗜𝗟",
                    controller: _emailController,
                    size: 447,
                    textWhiteColor: true,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "𝗦𝗘𝗡𝗛𝗔",
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
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }),

                  Obx(
                    () => SizedBox(
                      width: 447,
                      height: 44,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            theme.colorScheme.onSecondary,
                          ),
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
                            : const Text(
                                "𝗟𝗢𝗚𝗜𝗡",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // não estica a Row inteira
                      children: [
                        OutlinedButton(
                          onPressed: () => Get.toNamed("/register"),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "FAZER CADASTRO",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        OutlinedButton(
                          onPressed: () {}, // por enquanto não navega
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                             foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.yellow,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "ESQUECI A SENHA",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
